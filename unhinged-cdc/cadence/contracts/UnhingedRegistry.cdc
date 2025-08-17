import EVM from 0xf8d6e0586b0a20c7

access(all) contract UnhingedRegistry {

    access(all) let usernameToAddress: {String: String}
    access(all) let addressToUsername: {String: String}

    init() {
        self.usernameToAddress = {}
        self.addressToUsername = {}
    }

    access(all) fun register(username: String, address: String) {
        self.usernameToAddress[username] = address
        self.addressToUsername[address] = username
    }

    access(all) fun getAddress(username: String): String {
        return self.usernameToAddress[username] ?? ""
    }

    access(all) fun getUsername(address: String): String {
        return self.addressToUsername[address] ?? ""
    }
}