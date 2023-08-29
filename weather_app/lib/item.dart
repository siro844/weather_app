import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecast({super.key, required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return  Card(
                  elevation: 6,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(8.0),
                    child:  Column(children: [
                      Text(time,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                     Icon(icon,size: 32,),
                      const SizedBox(height: 8),
                      Text(
                        temp,
                      ),
                    ]
                    ),
                  ),
                );
  }
}
class AddInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AddInfo({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return   Column(
              children: [
                Icon(icon,size: 32,),
                 const SizedBox(height: 8),
                Text(label,style: const TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                 const SizedBox(height: 8),
                 Text(value,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            );
  }
}