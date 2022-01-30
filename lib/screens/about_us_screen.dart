import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);
  static const id = 'about_us';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 85),
          child: Text("About Us", style: TextStyle( fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 35),
            child: Image.asset('assets/Group.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              elevation: 40,
              child: Center(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(35),
                  title: Text('Who we are!' , textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30,fontWeight: FontWeight.bold)),
                  subtitle: const Text('VIO Health is a digital chronic care program developed by Medixia Global in 2021 to create an unprecedented experience for chronic patients in the middle east through a seamless journey across different providers and procedures. \n\n VIO Health closes gaps in the continuum of care \n\n Digitization in the healthcare industry has become a necessity to drive and maintain the quality of services. COVID-19 pandemic has changed the way we are thinking of care delivery and made digitalization a top-of-mind issue at every level of care. Tracing the care continuum from primary prevention to post-discharge care, rehabilitation service, and home care, VIO Health identified the real gaps and just designed the right approach to overcome them. Our evidence-based approach is delivering healthcare services for all population groups in a very personalized way. We developed the model based on three principles A-D-I, Adoption of value-based care models, Digitalization of care coordination, Implementation of data-driven pop... \n\n VIO Health is a value-driven concept that provides value-based care through state of art, high-quality, patient-centric, and data-driven clinical intervention programs for chronic patients. Our aim is to optimize the patient care process in a sustainable fashion to improve outcomes. \n\n We focus on providing personalized care that satisfies every patients needs and fits in his/her circumstances. Personalized care is a cornerstone for a paradigm shift in care management. This result in better care, better outcome, and better value.'),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
