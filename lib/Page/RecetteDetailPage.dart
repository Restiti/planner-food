// Page de Détails de la Recette
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/EtapeProvider.dart';
import '../model/Recette.dart';

class RecetteDetailPage extends StatelessWidget {
  final Recette recette;

  const RecetteDetailPage({super.key, required this.recette});

  @override
  Widget build(BuildContext context) {
    print(recette.nomRecette);
    return ChangeNotifierProvider(
      create: (_) => EtapeProvider(recette.idRecette!),
      child: Scaffold(
        appBar: AppBar(
          title: Text(recette.nomRecette),
        ),
        body: Consumer<EtapeProvider>(
          builder: (context, etapeProvider, child) {
            return etapeProvider.etapes.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: etapeProvider.etapes.length,
                    itemBuilder: (context, index) {
                      final etape = etapeProvider.etapes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(etape.numeroEtape.toString()),
                        ),
                        title: Text(etape.description),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
