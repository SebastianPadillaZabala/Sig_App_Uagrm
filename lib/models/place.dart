class PlaceList {
  int? idDatosUagrm;
  String? localidad;
  String? descripcion;
  String? nroModulo;
  String? aula;
  String? facultad;
  String? longitud;
  String? latitud;

  PlaceList(
      {this.idDatosUagrm,
      this.localidad,
      this.descripcion,
      this.nroModulo,
      this.aula,
      this.facultad,
      this.longitud,
      this.latitud});

  PlaceList.fromJson(Map<String, dynamic> json) {
    idDatosUagrm = json['Id_DatosUagrm'];
    localidad = json['Localidad'];
    descripcion = json['Descripcion'];
    nroModulo = json['Nro Modulo'];
    aula = json['Aula'];
    facultad = json['Facultad'];
    longitud = json['Longitud'];
    latitud = json['Latitud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id_DatosUagrm'] = this.idDatosUagrm;
    data['Localidad'] = this.localidad;
    data['Descripcion'] = this.descripcion;
    data['Nro Modulo'] = this.nroModulo;
    data['Aula'] = this.aula;
    data['Facultad'] = this.facultad;
    data['Longitud'] = this.longitud;
    data['Latitud'] = this.latitud;
    return data;
  }
}