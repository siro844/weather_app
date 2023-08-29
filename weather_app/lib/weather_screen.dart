import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weather_app/item.dart";
import 'package:http/http.dart' as http;
import "package:weather_app/secrets.dart";
class WeatherScreen extends StatefulWidget{
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    String city='Mumbai';
    try{
         final res= await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherAPI'));

     final data= jsonDecode(res.body);
    
     if(data['cod']!='200'){
      throw 'An unexpected Error Occured';
     }
    
     return data;

    }catch(e){
      throw e.toString();
    }
     
  }
  @override
  void initState() {
    super.initState();
    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    
  return  Scaffold(
   appBar:  AppBar(
    title: const Text(
      'WEATHER App',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    actions:  [
   IconButton(onPressed: (){setState(() {
     weather=getCurrentWeather();
   });}, icon: const Icon(Icons.refresh))
    
    ],
   ) ,
   body :  FutureBuilder(
    
    future: weather,
     builder: (context,snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if(snapshot.hasError){
        return Center(child: Text(snapshot.error.toString()));
      }
      final data= snapshot.data!;
      final currentWeather = data['list'][0];
      final temp=currentWeather['main']['temp'];
      final currentIcon=currentWeather['weather'][0]['main'];
      final celsius=temp-273.15;
      final pressure=currentWeather['main']['pressure'];
      final wind=currentWeather['wind']['speed'];
      final humidity=currentWeather['main']['humidity'];
       return Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //main card
          SizedBox(
            width:double.infinity,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                  child:  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('${celsius.toStringAsFixed(1)}°C', style: const TextStyle(
                          fontSize:32, 
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                         const SizedBox(height: 16),
                      Icon(
                        currentIcon =='Clouds'|| currentIcon=='Rain'
                         ? Icons.cloud:Icons.sunny,size: 64,),
                        const SizedBox(height: 16),
                         Text(currentIcon,style: const TextStyle(fontSize: 20),)
                  
                  
                      ]
                      ),
                  ),
                ),
              ),
            ),
          ),
     
            const SizedBox(height: 20),
     
            //forecast cards
            const Text('Hourly Forecast',
            style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
            ),)  ,
     
             const SizedBox(height: 15),
         
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                final hourlyforecast=data['list'][index+1];
                final houlytemp=hourlyforecast['main']['temp'] -273.15;
                final time=DateTime.parse(hourlyforecast['dt_txt']);
                  return HourlyForecast(
            time: DateFormat.Hm().format(time),
            icon:hourlyforecast['weather'][0]['main']=='Clouds'||  data['list'][index+1]['weather'][0]['main']=='Rain'?Icons.cloud :Icons.sunny,
            temp: houlytemp.toStringAsFixed(2)
                  );
              },
              ),
          ),
            //additional  cards
            const SizedBox(height: 16),
             
             const Text('Additional Information',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
               const SizedBox(height: 8),
        
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 AddInfo(icon:Icons.water_drop,label: 'Humidity',value: humidity.toString(),),
                  AddInfo(icon:Icons.air,label:'WindSpeed',value: wind.toString(),),
                   AddInfo(icon:Icons.beach_access,label: 'Pressure',value:  pressure.toString(),),
              ],
             )
        ],
       ),
     );
     },
   ),
  );
  }
}
