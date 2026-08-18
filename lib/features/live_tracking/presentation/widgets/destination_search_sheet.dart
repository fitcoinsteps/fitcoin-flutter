import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';

class DestinationSearchSheet extends StatefulWidget {
  const DestinationSearchSheet({super.key});

  @override
  State<DestinationSearchSheet> createState() => _DestinationSearchSheetState();
}

class _DestinationSearchSheetState extends State<DestinationSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  Future<void> _searchAndReturn() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        Navigator.pop(
          context,
          LocationPoint(
            latitude: loc.latitude,
            longitude: loc.longitude,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search destination...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isLoading ? null : _searchAndReturn,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Select Destination'),
          ),
        ],
      ),
    );
  }
}