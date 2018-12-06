include "base.thrift"

namespace java com.rbkmoney.damsel.messages

typedef base.ID UserId
typedef base.ID MessageId
typedef base.ID ConversationId


struct User {
    1: required UserId user_id // Какое у нас системное id? Стоит ли добавить роли?
    2: optional string name // Можем ли мы определить наше имя в системе и имя пользователя?
}

struct Message {
    1: required MessageId message_id
    2: required string text
    3: required User author
    4: required base.Timestamp timestamp // Надо ли? Чисто для сортировки. Мб в протоколе не надо.
}

struct Conversation {
    1: required ConversationId conversation_id
    2: required list<Message> messages
    3: required ConversationStatus status // Нужно ли в протоколе? Можно чисто для фильтрации оставить и внутри сервиса
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

exception ConversationsAlreadyExist {
    1: required list<ConversationId> ids
}

service MessageService {

    list<Conversation> GetConversations(1: list<ConversationId> conversation_ids, 2: ConversationFilter filter)
        throws (1: ConversationsNotFound ex)

    void SaveConversations(1: list<Conversation> conversations)
        throws (1: ConversationsAlreadyExist ex)

}