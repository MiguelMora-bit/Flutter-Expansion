import 'package:cached_network_image/cached_network_image.dart';
import 'package:fichas/models/fichas_model.dart';
import 'package:flutter/material.dart';

class FichasCard extends StatelessWidget {
  final Ficha ficha;

  const FichasCard({
    Key? key,
    required this.ficha,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 20),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(ficha.fotoUrl),
            _ProductDetails(
              title: "Folio:  ${ficha.folio}",
              subTitle: ficha.delegacion,
            ),
            Positioned(top: 0, right: 0, child: _StatusTag(ficha.status)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;

  const _ProductDetails({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 45),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 65,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subTitle,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: CachedNetworkImage(
          placeholder: (context, url) => Image.asset(
            'assets/loading.gif',
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          imageUrl: url!,
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String? status;

  const _StatusTag(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(status ?? "Sin revisar",
                style: const TextStyle(color: Colors.white, fontSize: 20))),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
    );
  }
}
