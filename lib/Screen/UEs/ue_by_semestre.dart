import 'package:flutter/material.dart';
import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/semestre.dart';
import 'package:school_management_system/Classes/ue.dart';
import 'package:school_management_system/Services/ue_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/colors.dart';

class UeBySemestre extends StatefulWidget {
  final Semestre semestre;
  const UeBySemestre({super.key, required this.semestre});

  @override
  State<UeBySemestre> createState() => _UeBySemestreState();
}

class _UeBySemestreState extends State<UeBySemestre> {
  late Future<List<UE>> futureUes;
  late List<Filiere> filieres = [];
  late List<Niveau> niveaux = [];
  final _formKey = GlobalKey<FormState>();
  final _codeUEController = TextEditingController();
  final _nomUEController = TextEditingController();
  late int? selectedFiliere = 0;
  late int? selectedNiveau = 0;
  late int? selectedSemestre = 0;
  late List<Niveau> filteredNiveaux = [];
  late List<Niveau> allNiveaux = [];
  int? selectedCredit;

  final List<int> credits = [4, 5, 6];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUes = UeService().getUesBySemestre(widget.semestre.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          " ${widget.semestre.nomSemestre} Liste des UES",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myredColor,
        onPressed: () {
          addUE(semestre: widget.semestre);
          _codeUEController.clear();
          _nomUEController.clear();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: FutureBuilder<List<UE>>(
              future: futureUes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(
                      "Error de recuperation des Semestres:${snapshot.error}");
                  return Center(
                    child: Text("Erreur: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Aucune UE trouvée"),
                  );
                } else {
                  List<UE> items = snapshot.data!;
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        UE ue = items[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            child: ListTile(
                              // leading: CircleAvatar(
                              //   backgroundColor: Colors.transparent,
                              //   radius: 30,
                              //   child: Text(
                              //     session.id.toString(),
                              //     style: TextStyle(
                              //         color: myredColor,
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 20),
                              //   ),
                              // ),

                              title: Text(ue.nomUE),

                              titleTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nombre de Crédit:",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        ue.nbreCredit.toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Modifiere
                                  IconButton(
                                      onPressed: () {
                                        updateUE(
                                            semestre: widget.semestre, ue: ue);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue.shade800,
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  //supprimer
                                  IconButton(
                                    onPressed: () {
                                      _confirmDelete(items[index].id!);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void addUE({required Semestre semestre}) async {
    // Vérifiez si les valeurs nécessaires sont présentes
    if (semestre.filiere.id == null ||
        semestre.niveau.id == null ||
        semestre.id == null) {
      print("Erreur : La filière, le niveau ou le semestre sont null !");
      return; // Stopper l'exécution si une valeur est manquante
    }

    // Afficher une boîte de dialogue pour saisir les détails de l'UE
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle  UE"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de saisie du code de l'UE
                  TextFormField(
                    controller: _codeUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Code de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le code de l'UE";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Champ de saisie du nom de l'UE
                  TextFormField(
                    controller: _nomUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Nom de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le nom de l'UE";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Nombre de Credit
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                        labelText: 'Volume Horaire',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    items: credits.map((int profil) {
                      return DropdownMenuItem<int>(
                        value: profil,
                        child: Text(profil.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCredit = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un profil';
                      }
                      return null;
                    },
                    value: selectedCredit,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            // Bouton Annuler
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: TextStyle(color: myredColor),
              ),
            ),

            // Bouton Ajouter
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Créer un objet UE avec les données saisies
                  final ue = UE(
                    nomUE: _nomUEController.text,
                    codeUE: _codeUEController.text,
                    nbreCredit: selectedCredit ?? 0,
                    filiere: semestre.filiere,
                    niveau: semestre.niveau,
                    semestre: semestre,
                    dateAjout: DateTime.now(),
                    modules: [],
                  );

                  // Envoyer l'UE à l'API Spring Boot
                  try {
                    String ueName = _nomUEController.text;
                    bool exists =
                        await UeService().ueExist(ueName, semestre.id);
                    if (exists) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: myredColor,
                          content: Text(
                            "Une UE avec ce nom existe dèja 😔",
                            style: TextStyle(color: Colors.white),
                          )));
                      return;
                    }

                    await UeService().addUeToSemestre(semestre.id, ue);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("UE ajoutée avec succès !")),
                    );
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : $e")),
                    );
                    print("Erreurrr:${e}");
                  }
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Supprimer un niveau
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce Semestre ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Appel à la méthode de suppression
                UeService().deleteUe(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureUes =
                        UeService().getUesBySemestre(widget.semestre.id!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Semestre supprimé avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $error")),
                  );
                });
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(
                'Supprimer',
                style: TextStyle(color: myredColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateUE({required Semestre semestre, required UE ue, id}) async {
    // Vérifiez si les valeurs nécessaires sont présentes
    if (semestre.filiere.id == null ||
        semestre.niveau.id == null ||
        semestre.id == null) {
      print("Erreur : La filière, le niveau ou le semestre sont null !");
      return; // Stopper l'exécution si une valeur est manquante
    }

    _codeUEController.text = ue.codeUE;
    _nomUEController.text = ue.nomUE;
    selectedCredit = ue.nbreCredit;
    // Afficher une boîte de dialogue pour saisir les détails de l'UE
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle  UE"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de saisie du code de l'UE
                  TextFormField(
                    controller: _codeUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Code de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le code de l'UE";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Champ de saisie du nom de l'UE
                  TextFormField(
                    controller: _nomUEController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Nom de l'UE",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer le nom de l'UE";
                      }
                      return null;
                    },
                  ),

                  //Volume Horaire

                  SizedBox(
                    height: 10,
                  ),
                  //Nombre de Credit
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                        labelText: 'Volume Horaire',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    items: credits.map((int profil) {
                      return DropdownMenuItem<int>(
                        value: profil,
                        child: Text(profil.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCredit = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un profil';
                      }
                      return null;
                    },
                    value: selectedCredit,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            // Bouton Annuler
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: TextStyle(color: myredColor),
              ),
            ),

            // Bouton Ajouter
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Créer un objet UE avec les données saisies
                  final uptadeUE = UE(
                    id: ue.id, // Assurez-vous que l'ID est passé

                    nomUE: _nomUEController.text,
                    codeUE: _codeUEController.text,
                    nbreCredit:
                        selectedCredit ?? 0, // Vous pouvez ajuster cette valeur
                    filiere: semestre.filiere,
                    niveau: semestre.niveau,
                    semestre: semestre,
                    dateAjout: DateTime.now(),
                    modules: [],
                  );

                  // Envoyer l'UE à l'API Spring Boot
                  try {
                    await UeService().updateUE(uptadeUE.id!, uptadeUE);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("UE mise à jour avec succès !")),
                    );
                    Navigator.of(context).pop();
                    setState(() {
                      futureUes =
                          UeService().getUesBySemestre(widget.semestre.id!);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : $e")),
                    );
                    print("Erreur : $e");
                  }
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
}
