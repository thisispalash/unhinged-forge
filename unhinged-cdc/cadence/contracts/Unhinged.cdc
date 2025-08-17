access(all) contract Unhinged {

    // Registry Stuff
    access(all) let usernameToAddress: {String _username: String _baseAddress}
    access(all) let addressToUsername: {String _address: String _username}
    access(all) let elo: {String _username: UFix64}

    access(all) let battles: {String _id: AnyStruct}
    access(all) let battleParticipants: {String _id: {String _username: String _baseAddress}}

    init() {
        self.usernameToAddress = {}
        self.addressToUsername = {}
        self.elo = {}
        self.battles = {}
        self.battleParticipants = {}
    }

    access(all) fun register(username: String, address: String) {
        self.usernameToAddress[username] = address
        self.addressToUsername[address] = username
        self.elo[username] = 1200.0
    }

    access(all) fun getAddress(username: String): String {
        return self.usernameToAddress[username] ?? ""
    }

    access(all) fun getUsername(address: String): String {
        return self.addressToUsername[address] ?? ""
    }

    access(all) fun getElo(username: String): UFix64 {
        return self.elo[username] ?? 1200.0
    }

}