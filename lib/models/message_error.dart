enum MessageType {
  success,
  warning,
  danger,
  info,
}

class MessageError {
  String message;
  MessageType messageType;

  MessageError({this.message, this.messageType});
}