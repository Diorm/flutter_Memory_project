// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:school_management_system/Classes/ue.dart';
// import 'package:school_management_system/Services/ue_service.dart';
// import 'package:school_management_system/Widgets/drawer.dart';
// import 'package:school_management_system/theme/colors.dart';


// class ListeDesUe extends StatefulWidget {
//   const ListeDesUe({super.key});

//   @override
//   _ListeDesUeState createState() => _ListeDesUeState();
// }

// class _ListeDesUeState extends State<ListeDesUe> {

//   late Future<List<UE>> futureUes;

//   final TextEditingController _codeUEController = TextEditingController();
//   final TextEditingController _nomUEController = TextEditingController();
//   String? selectedSession;
//   List<UE> ues = [];

//   final _formKey = GlobalKey<FormState>();

//   int? selectedNiveau;
//   int? selectedFiliere;
//   List<Niveau> filteredNiveaux = []; // Liste des niveaux filtrés
//   List<Niveau> allNiveaux = []; // Liste de tous les niveaux
//   List<Semestre> allSemestres = []; // Liste de tous les niveaux
//   List<Semestre> filtredSemestres = []; // Liste de tous les niveaux

//   int? selectedSemestre;

 
//   @override
//   void initState() {
//     super.initState();
//     futureUes =UeService().getUes();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//           "UNITES D'ENSEIGNEMENTS",
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Row(
//         children: [
//           MyDrawer(),
//           Expanded(
//             child: FutureBuilder(
//               future: futureUes, // Votre future ici
//               builder:
//                   (BuildContext context, AsyncSnapshot<List<UE>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//                   return const Center(child: Text("Aucun UE trouvée !!!"));
//                 } else if (snapshot.hasError) {
//                   return Text(snapshot.error.toString());
//                 } else {
//                   final List<UE> items = snapshot.data ?? <UE>[];
//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final UE ues = items[index];
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 3,
//                           child: ListTile(
//                             // leading: CircleAvatar(
//                             //   backgroundColor: Colors.transparent,
//                             //   radius: 30,
//                             //   child: Text(
//                             //     session.id.toString(),
//                             //     style: TextStyle(
//                             //         color: myredColor,
//                             //         fontWeight: FontWeight.bold,
//                             //         fontSize: 20),
//                             //   ),
//                             // ),
//                             title: Text("${ues.nomUE}"),
//                             titleTextStyle: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                                 fontSize: 20),
//                             subtitle: Row(
//                               children: [
//                                 Text("Crédits"),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   ues.nbreCredit.toString(),
//                                   style: TextStyle(
//                                       color: myredColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),

//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: Text("Suppression"),
//                                       content: Text(
//                                           "Voulez-vous vraiment retirer cette UE de la liste ?"),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text(
//                                             "Annuler",
//                                             style:
//                                                 TextStyle(color: myblueColor),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             (ues.id);
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text(
//                                             "Supprimer",
//                                             style: TextStyle(color: myredColor),
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                             onTap: () {
                          
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           addUE();
//         },
//         backgroundColor: myblueColor,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

  
//   Future<void> saveUE(String uename) async {

//     try {
//       bool exists = await UeService().ueExist(uename);
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
//         nbreCredit: ,
//         codeUE: _codeUEController.text,
//         nomUE: _nomUEController.text,
//         semestre: selectedSemestre,
//         dateAjout: DateTime.now(),
//         filiere: selectedFiliere
//       );

//       await UeService().createUe(newUE);

//       setState(() {
//         futureUes =
//             UeService().getUes();
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

//   void addUE() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Nouvelle Session"),
//               content: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // Dropdown pour sélectionner la filière
//                       FutureBuilder<List<Filiere>>(
//                         future: dbHelper.getFilieres(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text('Erreur: ${snapshot.error}'));
//                           } else if (snapshot.hasData &&
//                               snapshot.data!.isNotEmpty) {
//                             final filieres = snapshot.data!;
//                             return DropdownButtonFormField<int>(
//                               value: selectedFiliere,
//                               decoration: const InputDecoration(
//                                 labelText: "Sélectionner une Filière",
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: filieres.map((filiere) {
//                                 return DropdownMenuItem<int>(
//                                   value: filiere.id,
//                                   child: Text(filiere.nomFiliere),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFiliere = value;
//                                   selectedNiveau =
//                                       null; // Réinitialiser le niveau sélectionné
//                                   // Filtrer les niveaux en fonction de la filière sélectionnée
//                                   filteredNiveaux = allNiveaux
//                                       .where((niveau) =>
//                                           niveau.filiereId == selectedFiliere)
//                                       .toList();
//                                 });
//                               },
//                               validator: (int? value) {
//                                 if (value == null) {
//                                   return "Veuillez sélectionner une Filière";
//                                 }
//                                 return null;
//                               },
//                             );
//                           } else {
//                             return const Center(
//                                 child: Text("Aucune Filière trouvée."));
//                           }
//                         },
//                       ),

//                       const SizedBox(height: 20),

//                       // FutureBuilder pour récupérer tous les niveaux
//                       FutureBuilder<List<Niveau>>(
//                         future: dbHelper.getNiveaux(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text('Erreur: ${snapshot.error}'));
//                           } else if (snapshot.hasData &&
//                               snapshot.data!.isNotEmpty) {
//                             allNiveaux =
//                                 snapshot.data!; // Stocker tous les niveaux
//                             return DropdownButtonFormField<int>(
//                               value: selectedNiveau,
//                               decoration: const InputDecoration(
//                                 labelText: "Sélectionner un Niveau",
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: filteredNiveaux.map((niveau) {
//                                 return DropdownMenuItem<int>(
//                                   value: niveau.id,
//                                   child: Text(niveau.nomNiveau),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedNiveau =
//                                       value; // Mettre à jour le niveau sélectionné
//                                   selectedSemestre =
//                                       null; // Réinitialiser le niveau sélectionné
//                                   // Filtrer les Semestres en fonction du semestre sélectionné
//                                   filtredSemestres = allSemestres
//                                       .where((Semestre) =>
//                                           Semestre.niveauId == selectedNiveau)
//                                       .toList();
//                                 });
//                               },
//                               validator: (int? value) {
//                                 if (value == null) {
//                                   return "Veuillez sélectionner un Niveau";
//                                 }
//                                 return null;
//                               },
//                             );
//                           } else {
//                             return const Center(
//                                 child: Text("Aucun Niveau trouvé."));
//                           }
//                         },
//                       ),

//                       const SizedBox(height: 20),
//                       // FutureBuilder pour récupérer tous les semestre
//                       FutureBuilder<List<Semestre>>(
//                         future: dbHelper.getSemestres(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text('Erreur: ${snapshot.error}'));
//                           } else if (snapshot.hasData &&
//                               snapshot.data!.isNotEmpty) {
//                             allSemestres =
//                                 snapshot.data!; // Stocker tous les Semestres
//                             return DropdownButtonFormField<int>(
//                               value: selectedSemestre,
//                               decoration: const InputDecoration(
//                                 labelText: "Sélectionner un Semestre  ",
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: filtredSemestres.map((semestre) {
//                                 return DropdownMenuItem<int>(
//                                   value: semestre.id,
//                                   child: Text(semestre.nomSemestre),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedSemestre =
//                                       value; // Mettre à jour le niveau
//                                 });
//                               },
//                               validator: (int? value) {
//                                 if (value == null) {
//                                   return "Veuillez sélectionner un Niveau";
//                                 }
//                                 return null;
//                               },
//                             );
//                           } else {
//                             return const Center(
//                                 child: Text("Aucun Niveau trouvé."));
//                           }
//                         },
//                       ),

//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _codeUEController,
//                         validator: (String? value) {
//                           if (value == null || value.isEmpty) {
//                             return "Le champ ne doit pas être vide";
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Code UE",
//                           prefixIcon: const Icon(Icons.timeline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                       TextFormField(
//                         controller: _nomUEController,
//                         validator: (String? value) {
//                           if (value == null || value.isEmpty) {
//                             return "Le champ ne doit pas être vide";
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Nom UE",
//                           prefixIcon: const Icon(Icons.timeline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                   child: const Text(
//                     'Annuler',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     saveUE();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'Enregistrer',
//                     style: TextStyle(color: myblueColor),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
