package domain.types.core;


enum Sender {
    User;
    Bot;
}

typedef Message = {
    var sender:Sender;
    var content:String;
}

class ConversationModels {}