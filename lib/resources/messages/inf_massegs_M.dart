class Massegs {
  String? id;
  String? masseg;
  String? idUser;
  String? idusersender;
  String? idChat;
  String? Taype;
  String? state;
  DateTime? datnow;
  Massegs({
    this.id,
    this.idusersender,
    this.idUser,
    this.Taype,
    this.idChat,
    this.masseg,
    this.datnow,
    this.state,
  });
  Massegs.fromjson(Map<String, dynamic> json) {
    // final json=jsonc!.data();
    id = json["id"];
    idusersender = json["idusersender"];
    idUser = json["idUser"];
    Taype = json["Taype"];
    idChat = json["idChat"];
    masseg = json["masseg"];
    datnow = json["datnow"].toDate();
    state = json["state"];
  }
  Map<String, dynamic> tojson() {
    return {
      "id": id,
      "idusersender": idusersender,
      "idUser": idUser,
      "Taype": Taype,
      "idChat": idChat,
      "masseg": masseg,
      "datnow": datnow,
      "state": state
    };
  }
}
