import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend_app/presentation/pages/monitoring/kontrol_pakan_aerator.dart';
import '../../../widget/navigation/app_bar_widget.dart';
import '../riwayat_kualitas_air/riwayat_kualitas_air.dart';
import '../notifikasi.dart';
import '../../../widget/navigation/navigasi_monitoring.dart';
import '../../../widget/background_widget.dart';
import '../../../blocks/kolom_monitoring.dart';
import 'package:frontend_app/data/sensor_data_store.dart';

class Monitoring extends StatefulWidget {
  final String pondId;
  final String namePond;

  const Monitoring({super.key, required this.pondId, required this.namePond});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  bool isLoading = true;
  Timer? _sensorFetchTimer;

  final SensorDataStore _sensorStore = SensorDataStore();

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    _sensorFetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchSensorData();
    });
  }

  @override
  void dispose() {
    _sensorFetchTimer?.cancel();
    super.dispose();
  }

  void fetchSensorData() async {
    try {
      final ref = FirebaseDatabase.instance
          .ref("Sadewa_SmartFarm/ponds/${widget.pondId}/sensor_data");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final latestData = Map<String, dynamic>.from(snapshot.value as Map);

        if (mounted) {
          setState(() {
            _sensorStore.updateSensorHistory(widget.pondId, "temperature", latestData["temperature"]);
            _sensorStore.updateSensorHistory(widget.pondId, "ph", latestData["ph"]);
            _sensorStore.updateSensorHistory(widget.pondId, "salinity", latestData["salinity"]);
            _sensorStore.updateSensorHistory(widget.pondId, "turbidity", latestData["turbidity"]);

            _sensorStore.setSensorData(widget.pondId, latestData);
            isLoading = false;
          });
        }

      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      print("❌ Error: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final sensorHistory = {
      "temperature": _sensorStore.getHistory(widget.pondId, "temperature"),
      "ph": _sensorStore.getHistory(widget.pondId, "ph"),
      "salinity": _sensorStore.getHistory(widget.pondId, "salinity"),
      "turbidity": _sensorStore.getHistory(widget.pondId, "turbidity"),
    };


    return Scaffold(
      appBar: AppBarWidget(
        title: "Monitoring",
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundWidget(),

          Positioned(
            top: screenHeight * 0.0,
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            bottom: screenHeight * 0.10,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  KolomMonitoring(
                    pondId: widget.pondId,
                    sensorName: 'Sensor Suhu',
                    sensorType: 'temperature',
                    sensorData: sensorHistory["temperature"] ?? [],
                    namePond: widget.namePond,
                  ),
                  const SizedBox(height: 10),
                  KolomMonitoring(
                    pondId: widget.pondId,
                    sensorName: 'Sensor pH',
                    sensorType: 'ph',
                    sensorData: sensorHistory["ph"] ?? [],
                    namePond: widget.namePond,
                  ),
                  const SizedBox(height: 10),
                  KolomMonitoring(
                    pondId: widget.pondId,
                    sensorName: 'Sensor Salinitas',
                    sensorType: 'salinity',
                    sensorData: sensorHistory["salinity"] ?? [],
                    namePond: widget.namePond,
                  ),
                  const SizedBox(height: 10),
                  KolomMonitoring(
                    pondId: widget.pondId,
                    sensorName: 'Sensor Kekeruhan',
                    sensorType: 'turbidity',
                    sensorData: sensorHistory["turbidity"] ?? [],
                    namePond: widget.namePond,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Navigasi
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigasiMonitoring(
              selectedIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RiwayatKualitasAir(
                        pondId: widget.pondId,
                        namePond: widget.namePond,
                      ),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifikasi(
                        pondId: widget.pondId,
                        namePond: widget.namePond,
                      ),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KontrolPakanAerator(
                        pondId: widget.pondId,
                        namePond: widget.namePond,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}