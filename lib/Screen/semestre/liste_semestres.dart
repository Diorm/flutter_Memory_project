import 'package:flutter/material.dart';
import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/semestre.dart';
import 'package:school_management_system/Screen/UEs/add_ue-Screen.dart';
import 'package:school_management_system/Screen/UEs/ue_by_semestre.dart';
import 'package:school_management_system/Services/niveau_service.dart';
import 'package:school_management_system/Services/semestre_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/colors.dart';

class ListeSemestres extends StatefulWidget {
  final Niveau niveau;

  const ListeSemestres({super.key, required this.niveau});

  @override
  State<ListeSemestres> createState() => _ListeSemestresState();
}

class _ListeSemestresState extends State<ListeSemestres> {
  late Future<List<Semestre>> futureSemestres;
  String? selectedSemestre;

  @override
  void initState() {
    super.initState();
    futureSemestres = SemestreService().getSemestreByNiveau(widget.niveau.id!);
  }

  final List<String> semestres = [
    'Semestre 1',
    'Semestre 2',
    'Semestre 3',
    'Semestre 4',
    'Semestre 5',
    'Semestre 6',
  ];

  // Acronyme
  String getAcronym(String fullName) {
    List<String> words = fullName.split(' ');

    List<String> filteredWords = words.where((word) {
      return word.length > 2 || RegExp(r'^\d+$').hasMatch(word);
    }).toList();

    String acronym = '';

    if (filteredWords.isNotEmpty) {
      for (String word in filteredWords) {
        acronym += (word.length > 2) ? word[0] : word;
      }
    }

    return acronym.toUpperCase();
  }

  Future<void> saveSemestre(String nomSemestre) async {
    if (widget.niveau.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : ID du niveau manquant."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Récupérer la filière associée au niveau
      Filiere? filiere =
          await NiveauService().getFiliereByNiveauId(widget.niveau.id!);

      if (filiere == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Erreur : La filière associée au niveau est manquante."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Vérifier si le semestre existe déjà
      bool exists =
          await SemestreService().semestreExist(nomSemestre, widget.niveau.id!);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Un Semestre avec ce nom existe déjà."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Ajouter le semestre au niveau avec la filière récupérée
      await SemestreService().addSemestreToNiveau(widget.niveau.id!,
          nomSemestre, filiere // Passe la filière récupérée ici
          );

      setState(() {
        futureSemestres =
            SemestreService().getSemestreByNiveau(widget.niveau.id!);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Semestre ajouté avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'ajout : $error"),
          backgroundColor: Colors.red,
        ),
      );
      print("Erreur lors de l'ajout : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          " ${widget.niveau.nomNiveau} Liste des Semestres",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myredColor,
        onPressed: () {
          addSemestre();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: FutureBuilder<List<Semestre>>(
              future: futureSemestres,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Aucun Semestre trouvé"),
                  );
                } else {
                  List<Semestre> items = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 35.0,
                      mainAxisSpacing: 35.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final semes = items[index];

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UeBySemestre(
                                  semestre: semes,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double fontSize = constraints.maxHeight / 4;

                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                size: 25, color: Colors.red),
                                            onPressed: () {
                                              _confirmDelete(items[index].id!);
                                            },
                                          ),
                                        ],
                                      ),
                                      // Acronyme
                                      Text(
                                        getAcronym(semes.nomSemestre),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              fontSize, // Utiliser la taille calculée
                                          height:
                                              1, // Ajustez la hauteur de ligne si nécessaire
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Text(
                                              semes.nomSemestre,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void addSemestre() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nouveau Semestre"),
          content: SingleChildScrollView(
            // Permet le défilement si nécessaire
            child: Container(
              width: 300, // Définissez une largeur maximale
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    // Choix du profil
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Semestre",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: semestres.map((String profil) {
                        return DropdownMenuItem(
                          value: profil,
                          child: Text(profil),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemestre = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: TextStyle(color: myredColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedSemestre != null && selectedSemestre!.isNotEmpty) {
                  saveSemestre(selectedSemestre!).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez sélectionner un Semestre"),
                    ),
                  );
                }
              },
              child: Text('Ajouter'),
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
                SemestreService().deleteSemestre(id).then((_) {
                  // Rafraîchir la liste des niveaux
                  setState(() {
                    futureSemestres = SemestreService()
                        .getSemestreByNiveau(widget.niveau.id!);
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
}
