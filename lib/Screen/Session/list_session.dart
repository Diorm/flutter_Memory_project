import 'package:flutter/material.dart';
import 'package:school_management_system/Classes/session.dart';
import 'package:school_management_system/Services/service_session.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/theme/colors.dart';

class ListSession extends StatefulWidget {
  const ListSession({super.key});

  @override
  State<ListSession> createState() => _ListSessionState();
}

class _ListSessionState extends State<ListSession> {
  late Future<List<Session>> futureSessions;

  final TextEditingController _sessionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureSessions = ServiceSession().getSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Liste des Sessions",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          addSession();
        },
      ),
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: FutureBuilder<List<Session>>(
                future: futureSessions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Erreur:${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("Aucune  Session Trouvée"),
                    );
                  } else {
                    List<Session> items = snapshot.data!;
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          Session session = items[index];
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
                                title: Text("Session ${session.id}"),
                                titleTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                                subtitle: Text(session.nomSession),
                                subtitleTextStyle: TextStyle(
                                    color: myredColor,
                                    fontWeight: FontWeight.bold),
                                trailing: IconButton(
                                  onPressed: () {
                                    _confirmDelete(items[index].id!);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: myredColor,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }

  void addSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nouvelle Session"),
          content: Form(
            child: TextFormField(
              controller: _sessionController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le champ ne doit pas être vide";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Session",
                hintText: "2023/2024",
                prefixIcon: const Icon(Icons.timeline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                String sessionName = _sessionController.text;
                if (sessionName.isNotEmpty) {
                  saveSession(sessionName).then((_) {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Veuillez entrer un nom de session",
                          style: TextStyle(color: Colors.white),
                        )),
                  );
                }
              },
              child: Text(
                'Enregistrer',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette session ?"),
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
                ServiceSession().deleteSession(id).then((_) {
                  // Rafraîchir la liste des sessions
                  setState(() {
                    futureSessions = ServiceSession().getSessions();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Session supprimée avec succès"),
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

  Future<void> saveSession(String sessionName) async {
    try {
      // Créer une instance de Session avec le bon nom
      Session newSession = Session(nomSession: sessionName);

      // Appeler le service pour ajouter la session
      await ServiceSession().createSession(newSession);

      // Rafraîchir la liste des sessions après l'ajout
      setState(() {
        futureSessions = ServiceSession().getSessions();
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Session ajoutée avec succès")),
      );
    } catch (error) {
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout : $error")),
      );
    }
  }
}
