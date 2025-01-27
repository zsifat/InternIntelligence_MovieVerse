import 'package:flutter/material.dart';
import 'package:movie_app/config/app_settings.dart';

class CastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cast; // Assume a list of cast data with name and imageUrl

  const CastWidget({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: AppSettings.regularSemibold,
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final member = cast[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        member['imageUrl'] ?? 'https://upload.wikimedia.org/wikipedia/en/6/60/No_Picture.jpg',
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.network(
                            'https://upload.wikimedia.org/wikipedia/en/6/60/No_Picture.jpg',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          );
                        },
                      )

                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      member['name'] ?? 'Unknown',
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
