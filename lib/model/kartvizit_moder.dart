// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kartvizit {
  String? name;
  String? surName;
  String? fulName;
  String? companyName;
  List<String>? telNo;
  String? adres;
  String? mail;
  String? webAdress;
  Kartvizit({
    this.name,
    this.surName,
    this.fulName,
    this.companyName,
    this.telNo,
    this.adres,
    this.mail,
    this.webAdress,
  });

  @override
  String toString() {
    return 'Kartvizit(name: $name, surName: $surName, companyName: $companyName, telNo: $telNo, adres: $adres, mail: $mail, webAdress: $webAdress)';
  }
}
