// import 'package:flutter/material.dart';
// import 'package:school_management_system/Classes/filiere.dart';
// import 'package:school_management_system/Classes/niveau.dart';
// import 'package:school_management_system/Classes/semestre.dart';
// import 'package:school_management_system/Classes/ue.dart';
// import 'package:school_management_system/Services/filiere_service.dart';
// import 'package:school_management_system/Services/niveau_service.dart';
// import 'package:school_management_system/Services/semestre_service.dart';
// import 'package:school_management_system/Services/ue_service.dart';
// import 'package:school_management_system/Widgets/drawer.dart';
// import 'package:school_management_system/theme/colors.dart';

// class ListeDesUES extends StatefulWidget {
//   final Semestre semestre;
//   const ListeDesUES({super.key, required this.semestre});

//   @override
//   State<ListeDesUES> createState() => _ListeDesUESState();
// }

// class _ListeDesUESState extends State<ListeDesUES> {
//   late Future<List<UE>> futureUes;
//   late List<Filiere> filieres = [];
//   late List<Niveau> niveaux = [];
//   final _formKey = GlobalKey<FormState>();
//   final _codeUEController = TextEditingController();
//   final _nonUEController = TextEditingController();
//   late int? selectedFiliere = 0;
//   late int? selectedNiveau = 0;
//   late List<Niveau> filteredNiveaux = [];
//   late List<Niveau> allNiveaux = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     futureUes = UeService().getUesBySemestre(widget.semestre.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(
//           " ${widget.semestre.nomSemestre} Liste des UEs",
//           style: TextStyle(
//               fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: myredColor,
//         onPressed: () {
//           addUE();
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: Row(
//         children: [
//           MyDrawer(),
//           Expanded(
//             child: FutureBuilder<List<UE>>(
//               future: futureUes,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text("Erreur: ${snapshot.error}"),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Text("Aucune UE trouvée"),
//                   );
//                 } else {
//                   List<UE> items = snapshot.data!;
//                   return ListView.builder(
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         UE ue = items[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 3,
//                             child: ListTile(
//                               // leading: CircleAvatar(
//                               //   backgroundColor: Colors.transparent,
//                               //   radius: 30,
//                               //   child: Text(
//                               //     session.id.toString(),
//                               //     style: TextStyle(
//                               //         color: myredColor,
//                               //         fontWeight: FontWeight.bold,
//                               //         fontSize: 20),
//                               //   ),
//                               // ),
//                               title: Text("UE ${ue.id}"),
//                               titleTextStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 20),
//                               subtitle: Text(ue.nomUE),
//                               subtitleTextStyle: TextStyle(
//                                   color: myredColor,
//                                   fontWeight: FontWeight.bold),
//                               trailing: IconButton(
//                                 onPressed: () {
//                                   _confirmDelete(items[index].id!);
//                                 },
//                                 icon: Icon(
//                                   Icons.delete,
//                                   color: myredColor,
//                                 ),
//                               ),
//                               onTap: () {},
//                             ),
//                           ),
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void addUE() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Ajouter une UE"),
//               content: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       //Dropdown pour selectionner la filiere
//                       FutureBuilder<List<Filiere>>(
//                         future: FiliereService().getFilieres(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text("Erreur: ${snapshot.error}"));
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return const Center(
//                                 child: Text("Aucune filière trouvée"));
//                           }

//                           final filieres = snapshot.data!;
//                           return DropdownButtonFormField<int>(
//                             value: filieres.any(
//                                     (filiere) => filiere.id == selectedFiliere)
//                                 ? selectedFiliere
//                                 : null,
//                             decoration: const InputDecoration(
//                               labelText: "Sélectionner une Filière",
//                               border: OutlineInputBorder(),
//                             ),
//                             items: filieres.map((filiere) {
//                               return DropdownMenuItem<int>(
//                                 value: filiere.id,
//                                 child: Text(filiere.nomFiliere),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedFiliere = value;
//                                 selectedNiveau = null;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null)
//                                 return "Veuillez sélectionner une filière";
//                               return null;
//                             },
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 10),
// // Utiliser une clé pour forcer la reconstruction du FutureBuilder
//                       FutureBuilder<List<Niveau>>(
//                         key: ValueKey(
//                             selectedFiliere), // Clé unique basée sur selectedFiliere
//                         future: selectedFiliere != null
//                             ? NiveauService()
//                                 .getNiveauxByFiliere(selectedFiliere!)
//                             : Future.value(
//                                 []), // Retourner une liste vide si selectedFiliere est null
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text("Erreur: ${snapshot.error}"));
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return const Center(
//                                 child: Text("Aucun niveau trouvé"));
//                           }

//                           final niveaux = snapshot.data!;
//                           return DropdownButtonFormField<int>(
//                             value: selectedNiveau,
//                             decoration: const InputDecoration(
//                               labelText: "Sélectionner un Niveau",
//                               border: OutlineInputBorder(),
//                             ),
//                             items: niveaux.map((niveau) {
//                               return DropdownMenuItem<int>(
//                                 value: niveau.id,
//                                 child: Text(niveau.nomNiveau),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedNiveau = value;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null)
//                                 return "Veuillez sélectionner un niveau";
//                               return null;
//                             },
//                           );
//                         },
//                       ),
//                       TextFormField(
//                         controller: _codeUEController,
//                         decoration: const InputDecoration(
//                           labelText: "Code de l'UE",
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Veuillez entrer le code de l'UE";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: _nonUEController,
//                         decoration: const InputDecoration(
//                           labelText: "Nom de l'UE",
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Veuillez entrer le code de l'UE";
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Annuler"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       saveUE(_codeUEController.text);
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: const Text("Ajouter"),
//                 ),
//               ],
//             );
//           });
//         });
//   }

//   Future<void> saveUE(String uename) async {
//     if (widget.semestre.id == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Erreur : L'ID de la filière est manquant."),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     try {
//       bool exists = await UeService().ueExist(uename, widget.semestre.id!);
//       if (exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Un Semestre avec ce nom existe déjà."),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       UE newUE = UE(
//           nomUE: uename,
//           codeUE: _codeUEController.text,
//           nbreCredit: 6,
//           filiere: selectedFiliere,
//           semestreId: widget.semestre.id, // Utilisez l'ID de la filière
//           dateAjout: DateTime.now(),
//           niveau: selectedNiveau);

//       await UeService().addUeToSemestre(widget.semestre.id!, newUE);

//       setState(() {
//         futureUes = UeService().getUesBySemestre(widget.semestre.id!);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Semestre ajouté avec succès."),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Erreur lors de l'ajout : $error"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Supprimer un niveau
//   void _confirmDelete(int id) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Confirmation"),
//           content:
//               const Text("Êtes-vous sûr de vouloir supprimer ce Semestre ?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Ferme la boîte de dialogue
//               },
//               child: const Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Appel à la méthode de suppression
//                 SemestreService().deleteSemestre(id).then((_) {
//                   // Rafraîchir la liste des niveaux
//                   setState(() {
//                     futureUes =
//                         UeService().getUesBySemestre(widget.semestre.id!);
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Semestre supprimé avec succès"),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }).catchError((error) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Erreur : $error")),
//                   );
//                 });
//                 Navigator.of(context).pop(); // Ferme la boîte de dialogue
//               },
//               child: Text(
//                 'Supprimer',
//                 style: TextStyle(color: myredColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
