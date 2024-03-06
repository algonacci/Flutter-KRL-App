import 'package:flutter/material.dart';
import 'package:krl_app/components/commuter_line_tile.dart';
import 'package:get/get.dart';
import 'package:krl_app/pages/schedule_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KRL App'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Jabodetabek Area',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommuterLineTile(
            imagePath: 'assets/img/bogor.png',
            title: 'Commuter Line Bogor',
            subtitle: 'Jakarta Kota - Bogor',
            onTap: () {
              // Navigasi ke halaman detail atau halaman jadwal kereta Bogor
            },
          ),
          CommuterLineTile(
            imagePath: 'assets/img/cikarang.png',
            title: 'Commuter Line Cikarang',
            subtitle: 'Jakarta Kota - Cikarang',
            onTap: () {},
          ),
          CommuterLineTile(
            imagePath: 'assets/img/rangkas.png',
            title: 'Commuter Line Rangkasbitung',
            subtitle: 'Tanah Abang - Rangkasbitung',
            onTap: () {},
          ),
          CommuterLineTile(
            imagePath: 'assets/img/tangerang.png',
            title: 'Commuter Line Tangerang',
            subtitle: 'Duri - Tangerang',
            onTap: () {},
          ),
          CommuterLineTile(
            imagePath: 'assets/img/tanjung_priok.png',
            title: 'Commuter Line Tanjung Priok',
            subtitle: 'Jakarta Kota - Tanjung Priok',
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Yogyakarta Area',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CommuterLineTile(
            imagePath: 'assets/img/yogya.png',
            title: 'Commuter Line Yogyakarta',
            subtitle: 'Yogyakarta - Palur',
            onTap: () {
              Get.to(() => SchedulePage(stations: const [
                    'YK',
                    'LPN',
                    'MGW',
                    'BBN',
                    'SWT',
                    'KT',
                    'CE',
                    'DL',
                    'GW',
                    'PWS',
                    'SLO',
                    'PL',
                  ]));
            },
          ),
        ],
      ),
    );
  }
}
