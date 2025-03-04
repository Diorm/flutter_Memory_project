import 'package:flutter/material.dart';
import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Screen/Niveaux/list_niveau.dart';
import 'package:school_management_system/Services/filiere_service.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/colors.dart';

class ListFilieres extends StatefulWidget {
  @override
  _ListFilieresState createState() => _ListFilieresState();
}

class _ListFilieresState extends State<ListFilieres> {
  late Future<List<Filiere>> futureFilieres;

  final TextEditingController _nomFiliereController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureFilieres = FiliereService().getFilieres();
  }

  //Acronyme

  String getAcronym(String fullName) {
    List<String> words = fullName.split(' ');

    List<String> filteredWords = words.where((word) {
      return word.length > 2; // Ignore words like "de", "et", "le", etc.
    }).toList();

    String acronym = '';

    if (filteredWords.length > 1) {
      acronym = filteredWords[0][0] + filteredWords[1][0];
    } else if (filteredWords.isNotEmpty) {
      acronym = filteredWords[0][0];
    }

    return acronym.toUpperCase(); // Convert to uppercase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Liste des Filieres",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          addDialog();

          _nomFiliereController.clear();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: FutureBuilder<List<Filiere>>(
              future: futureFilieres,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Erreur : ${snapshot.error}");
                  return Center(
                    child: Text(
                      "Erreur : ${snapshot.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucune filière trouvée",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  List<Filiere> items = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 35.0,
                      mainAxisSpacing: 35.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final filiere = items[index];
                      return _buildFiliereCard(filiere);
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

  Widget _buildFiliereCard(Filiere filiere) {
 
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListesNiveaux(filiere: filiere),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              size: 25, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(filiere.id!);
                          },
                        ),
                      ],
                    ),
                    Text(
                      getAcronym(filiere.nomFiliere),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            filiere.nomFiliere,
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
  }

  void addDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nouvelle Filière"),
          content: SingleChildScrollView(
            // Permet le défilement si nécessaire
            child: Container(
              width: 300, // Définissez une largeur maximale
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Réduit la taille au minimum
                  children: [
                    TextFormField(
                      controller: _nomFiliereController,
                      decoration: InputDecoration(
                          labelText: 'Nom de la Filière',
                          prefixIcon: Icon(Icons.bookmarks),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Le champ ne doit pas etre vide";
                        }
                        return null;
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
                String filiereName = _nomFiliereController.text;
                if (filiereName.isNotEmpty) {
                  saveFiliere(filiereName).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Veuillez entrer un nom de Filiere")),
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

  //SaveFiliere
  // Dans ListFilieres.dart

  Future<void> saveFiliere(String filiereName) async {
    try {
      // Vérification si la filière existe déjà
      bool exists = await FiliereService().filiereExists(filiereName);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Une filière avec ce nom existe déjà"),
          ),
        );
        return; // Sortir si elle existe déjà
      }

      Filiere nouveauFiliere = Filiere(nomFiliere: filiereName);
      await FiliereService().createFiliere(nouveauFiliere);

      setState(() {
        futureFilieres = FiliereService().getFilieres();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Filière ajoutée avec succès",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Erreur lors de l'ajout : $error",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      print('Echec lors de l\'ajout  de la Filiere : $error');
    }
  }

  //Supprimer une Filiere

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette Filiere ?"),
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
                FiliereService().deleteFiliere(id).then((_) {
                  // Rafraîchir la liste des Filieres
                  setState(() {
                    futureFilieres = FiliereService().getFilieres();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Filiere supprimée avec succès"),
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
