include "base.thrift"

namespace java com.rbkmoney.damsel.messages

typedef base.ID UserId
typedef base.ID MessageId
typedef base.ID ConversationId


struct User {
    1: required UserId user_id
    2: required string email
    3: required string fullname
}

struct Message {
    1: required MessageId message_id
    2: required string text
    3: required UserId user_id
    4: required base.Timestamp timestamp
}

struct Conversation {
    1: required ConversationId conversation_id
    2: required list<Message> messages
    3: required ConversationStatus status
}

enum ConversationStatus {
    ACTUAL
    OUTDATED
}

struct ConversationFilter {
    1: optional ConversationStatus conversation_status
}

exception ConversationsNotFound {
    1: required list<ConversationId> ids
}

struct GetConversationResponse {
    1: required list<Conversation> conversations
    2: required map<UserId, User> users
}

service MessageService {

    GetConversationResponse GetConversations(1: list<ConversationId> conversation_ids, 2: ConversationFilter filter)
        throws (1: ConversationsNotFound ex)

    void SaveConversations(1: list<Conversation> conversations, 2: User user)

}
