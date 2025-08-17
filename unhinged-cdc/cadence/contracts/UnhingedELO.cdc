access(all) contract EloRatings {

    access(all) let ratings: {EVM.EVMAddress: UFix64}

    access(all) let K: UFix64
    access(all) let SCALE: UFix64
    access(all) let THRESHOLD_DIFF: UFix64
    access(all) let NPC_BONUS_FACTOR: UFix64
    access(all) let SCORE_MIN: UFix64
    access(all) let SCORE_MAX: UFix64

    init() {
        self.ratings = {}
        self.K = 32.0
        self.SCALE = 400.0
        self.THRESHOLD_DIFF = 400.0
        self.NPC_BONUS_FACTOR = 0.5
        self.SCORE_MIN = 0.0
        self.SCORE_MAX = 3.0
    }

    access(all) fun getRating(addr: EVM.EVMAddress): UFix64 {
        return self.ratings[addr] ?? 1200.0
    }

    // Check threshold for proposed challenger
    access(all) fun canAddChallenger(defender: EVM.EVMAddress, proposedChall: EVM.EVMAddress): Bool {
        let rDef = self.getRating(addr: defender)
        let rChall = self.getRating(addr: proposedChall)
        let diff = rDef > rChall ? rDef - rChall : rChall - rDef
        return diff <= self.THRESHOLD_DIFF
    }

    // Aggregated update
    // baseOutcomeDef: Base for defender (0.0-3.0)
    // baseOutcomesChall: Array bases for challengers
    // npcVotesDef: Votes against defender
    // npcVotesChall: Array votes against each challenger
    // isWinDef: True if defender won overall (for mod sign)
    // isDraw: True if draw (neutral mod)
    access(all) fun updateMulti(defender: Address, challengers: [Address], baseOutcomeDef: UFix64, baseOutcomesChall: [UFix64], npcVotesDef: UInt64, npcVotesChall: [UInt64], isWinDef: Bool, isDraw: Bool) {
        assert(challengers.length == baseOutcomesChall.length && challengers.length == npcVotesChall.length, message: "Arrays mismatch")

        var rDef = self.getRating(addr: defender)
        var sumRChall: UFix64 = 0.0
        for chall in challengers {
            sumRChall = sumRChall + self.getRating(addr: chall)
        }
        let avgRChall = challengers.length > 0 ? sumRChall / UFix64(challengers.length) : 1200.0  // Default if no chall

        // Expected for defender
        let diff = (avgRChall - rDef) / self.SCALE
        let expDef = 1.0 / (1.0 + 10.0.pow(diff))  // Or linear: let expDef = 0.5 + (rDef - avgRChall) / (2.0 * self.SCALE); if expDef < 0.0 {expDef=0.0} else if expDef > 1.0 {expDef=1.0}

        // NPC mod calc
        fun calcNpcMod(n: UInt64, isWin: Bool, isDraw: Bool): UFix64 {
            if n == 0 { return 0.0 }
            let un = UFix64(n)
            let mult = (un + 1.0) * (2.0 * un + 1.0) / 6.0
            if isDraw { return -mult * 0.25 }  // Slight penalty if accused in draw
            return isWin ? mult * self.NPC_BONUS_FACTOR : -mult * self.NPC_BONUS_FACTOR
        }

        // Defender final score
        let npcModDef = calcNpcMod(n: npcVotesDef, isWin: isWinDef, isDraw: isDraw)
        var finalDef = baseOutcomeDef + npcModDef
        if finalDef < self.SCORE_MIN { finalDef = self.SCORE_MIN }
        if finalDef > self.SCORE_MAX { finalDef = self.SCORE_MAX }

        let changeDef = self.K * (finalDef - expDef)
        rDef = rDef + changeDef
        self.ratings[defender] = rDef

        // Challengers (inverse exp, per-player mods)
        let expChall = 1.0 - expDef
        let isWinChall = !isWinDef  // Challengers win if defender loses
        var i: Int = 0
        while i < challengers.length {
            let rChall = self.getRating(addr: challengers[i])
            let npcModChall = calcNpcMod(n: npcVotesChall[i], isWin: isWinChall, isDraw: isDraw)
            var finalChall = baseOutcomesChall[i] + npcModChall
            if finalChall < self.SCORE_MIN { finalChall = self.SCORE_MIN }
            if finalChall > self.SCORE_MAX { finalChall = self.SCORE_MAX }

            let changeChall = self.K * (finalChall - expChall)
            self.ratings[challengers[i]] = rChall + changeChall
            i = i + 1
        }
    }
}