class VeterinaryModel {
  String? tin;
  String? dti;
  String? bir;
  List<dynamic>? operation;
  List<dynamic>? services;
  List<dynamic>? specialties;
  String? description;
  String? lat;
  String? long;
  int? valid;
  String? clinicname;
  String? imageprofile;
  String? dateestablished;
  int? ishaveadoctor;
  int? isclose;

  VeterinaryModel(
      {this.valid,
      this.tin,
      this.dti,
      this.bir,
      this.operation,
      this.services,
      this.imageprofile,
      this.specialties,
      this.description,
      this.lat,
      this.long,
      this.clinicname,
      this.ishaveadoctor,
      this.isclose,
      this.dateestablished});

  factory VeterinaryModel.getdocument(map) {
    return VeterinaryModel(
      valid: map['valid'],
      tin: map['tin'],
      dti: map['dti'],
      bir: map['bir'],
      ishaveadoctor: map['ishaveadoctor'],
      imageprofile: map['imageprofile'],
      clinicname: map['clinicname'],
      operation: map['operation'],
      services: map['services'],
      specialties: map['specialties'],
      description: map['description'],
      lat: map['lat'],
      isclose: map['isclose'],
      long: map['long'],
      dateestablished: map['dateestablished'],
    );
  }

  Map<String, dynamic> veterinarymap() {
    return {
      'valid': 1,
      "tin": tin,
      "clinicname": clinicname,
      "dti": dti,
      "bir": bir,
      "ishaveadoctor": 1,
      "isclose": 0,
      "imageprofile": imageprofile,
      "operation": operation,
      "services": services,
      "specialties": specialties,
      "description": description,
      "lat": lat,
      "long": long,
      "dateestablished": dateestablished,
    };
  }
}
