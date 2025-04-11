// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract DiaryContract {
    struct Entry {
        uint id;
        address owner;
        string title;
        string content;
        bool isPublic;
        bool isDeleted;
        uint createdAt;
    }

    struct Comment {
        address commenter;
        string message;
        uint timestamp;
    }

    // Entry ID => Entry
    mapping(uint => Entry) public entries;

    // Entry ID => Comments
    mapping(uint => Comment[]) public comments;

    // User address => array of entry IDs
    mapping(address => uint[]) public entriesOf;

    // Access Control: owner => editor => true/false
    mapping(address => mapping(address => bool)) public editors;

    uint public nextEntryId;

    // Internal function to add entry
    function _addEntry(
        address _owner,
        string memory _title,
        string memory _content,
        bool _isPublic
    ) internal {
        require(_owner == msg.sender || editors[_owner][msg.sender], "Not authorized");

        entries[nextEntryId] = Entry(
            nextEntryId,
            _owner,
            _title,
            _content,
            _isPublic,
            false,
            block.timestamp
        );

        entriesOf[_owner].push(nextEntryId);
        nextEntryId++;
    }

    // Add own entry
    function addEntry(string memory _title, string memory _content, bool _isPublic) public {
        _addEntry(msg.sender, _title, _content, _isPublic);
    }

    // Add entry for someone else (authorized)
    function addEntryFor(address _owner, string memory _title, string memory _content, bool _isPublic) public {
        _addEntry(_owner, _title, _content, _isPublic);
    }

    // Soft delete an entry
    function deleteEntry(uint _entryId) public {
        Entry storage e = entries[_entryId];
        require(e.owner == msg.sender, "Not your entry");
        e.isDeleted = true;
    }

    // Grant access to another address
    function allowEditor(address _editor) public {
        editors[msg.sender][_editor] = true;
    }

    // Revoke access
    function disallowEditor(address _editor) public {
        editors[msg.sender][_editor] = false;
    }

    // Add a comment to a public entry
    function addComment(uint _entryId, string memory _message) public {
        Entry storage e = entries[_entryId];
        require(e.isPublic && !e.isDeleted, "Entry not commentable");
        comments[_entryId].push(Comment(msg.sender, _message, block.timestamp));
    }

    // Get comments of an entry
    function getComments(uint _entryId) public view returns (Comment[] memory) {
        return comments[_entryId];
    }

    // Get latest N entries for a user (excluding deleted)
    function getLatestEntries(address _user, uint count) public view returns (Entry[] memory) {
        uint[] memory ids = entriesOf[_user];
        require(count <= ids.length, "Not enough entries");

        Entry[] memory result = new Entry[](count);
        uint j = 0;

        for (uint i = ids.length - count; i < ids.length; i++) {
            Entry storage e = entries[ids[i]];
            result[j++] = e;
        }

        return result;
    }

    // Get public entries between timestamps (not deleted)
    function getEntriesBetween(
        address _user,
        uint start,
        uint end
    ) public view returns (Entry[] memory) {
        uint[] memory ids = entriesOf[_user];
        Entry[] memory temp = new Entry[](ids.length);
        uint count = 0;

        for (uint i = 0; i < ids.length; i++) {
            Entry storage e = entries[ids[i]];
            if (
                e.createdAt >= start &&
                e.createdAt <= end &&
                e.isPublic &&
                !e.isDeleted
            ) {
                temp[count] = e;
                count++;
            }
        }

        // Resize memory array
        Entry[] memory result = new Entry[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = temp[i];
        }

        return result;
    }
}
