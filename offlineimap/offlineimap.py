#!/usr/bin/python

import gnomekeyring as gkey

class Keyring(object):
    def __init__(self, name, server, protocol):
        self._name = name
        self._server = server
        self._protocol = protocol
        self._keyring = gkey.get_default_keyring_sync()

    def has_credentials(self):
        try:
            attrs = {"server": self._server, "protocol": self._protocol}
            items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
            return len(items) > 0
        except gkey.DeniedError:
            return False

    def get_credentials(self):
        attrs = {"server": self._server, "protocol": self._protocol}
        items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
        return (items[0].attributes["user"], items[0].secret)

    def set_credentials(self, (user, pw)):
        attrs = {
            "user": user,
            "server": self._server,
            "protocol": self._protocol,
        }
        gkey.item_create_sync(gkey.get_default_keyring_sync(),
                              gkey.ITEM_NETWORK_PASSWORD, self._name, attrs, pw, True)

def get_username(server):
    keyring = Keyring("offlineimap", server, "imap")
    (username, password) = keyring.get_credentials()
    return username

def get_password(server):
    keyring = Keyring("offlineimap", server, "imap")
    (username, password) = keyring.get_credentials()
    return password


def folder_filter(foldername):
    return foldername not in ['[Gmail]/All Mail', '[Gmail]/Spam', '[Gmail]/Important',
                              'Clojure', 'Haskell-Cafe', 'Haskell', 'Perl5 Porters',
                              'EH', 'PF', 'stuff', 'Interesting Links', 'Notes',
                              'Datamill Errors']

mailbox_translations = {
    "[Gmail]/Starred":       "bak.flagged",
    "TA emails":             "ta_emails",
    "Sebastian (PhD stuff)": "sebastian_(phd_stuff)",
    "INBOX":                 "inbox",
    "Orders Ongoing":        "orders_ongoing",
    "kernelnewbies":         "kernelnewbies",
    "[Gmail]/Sent Mail":     "bak.sent",
    "Bitbucket Issues":      "bitbucket_issues",
    "[Gmail]/Trash":         "bak.trash",
    "[Gmail]/Drafts":        "bak.drafts",
    "suckless":              "suckless"
}


def name_trans(foldername):
    if foldername in mailbox_translations:
        return mailbox_translations[foldername]
    else:
        return foldername

def reverse_name_trans(foldername):
    reverse_translations = {v: k for k, v in mailbox_translations.items()}
    if foldername in reverse_translations:
        return reverse_translations[foldername]
    else:
        return foldername
