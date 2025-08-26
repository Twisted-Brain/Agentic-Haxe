package domain.types.http;

typedef LlmRequest = {
    var prompt:String;
    var model:String;
}

typedef LlmResponse = {
    var response:String;
    var model:String;
}