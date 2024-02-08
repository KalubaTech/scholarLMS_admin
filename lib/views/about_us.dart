import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 800,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: ListView(
                    children: [
                      Image.asset('assets/scholar.png', height: 100, width: 100),
                      SizedBox(height: 16.0),
                      Text(
                        'Welcome to Scholar LMS',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Our Vision',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'We envision a future where education transcends boundaries, and every learner has access to a dynamic, personalized, and globally competitive learning environment. Scholar LMS is designed to be a catalyst for this transformation, creating opportunities for educational excellence and growth.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Zambian Innovation, Global Impact',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scholar LMS stands out as a testament to Zambian innovation and technological prowess. Developed locally, our system incorporates the unique cultural and educational needs of Zambia while adhering to global standards of excellence. We take pride in contributing to the global ed-tech landscape with a solution that reflects the diversity and richness of Zambian education.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Features and Functionality',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scholar LMS is a comprehensive platform catering to lecturers, students, and parents alike. Our ecosystem comprises dedicated apps for each role, ensuring a tailored experience for everyone involved in the educational journey.',
                      ),
                      // Add more sections as needed

                      SizedBox(height: 16.0),
                      Text(
                        'Join Us in Shaping the Future',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scholar LMS invites educators, students, and parents to join us in shaping the future of education. Whether you are a part of a traditional classroom setting or engaged in remote learning, our platform is designed to meet your needs and exceed your expectations.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Experience the power of education technology with Scholar LMS – where learning knows no bounds. Together, let\'s build a brighter future for education in Zambia and beyond.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Our Commitment to Excellence',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'At Scholar LMS, we are committed to excellence in education technology. Our team of dedicated professionals continually works to enhance and expand our platform, ensuring that it remains at the forefront of educational innovation. We value feedback from our users and actively incorporate suggestions to create a more robust and user-friendly system.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Join Us in Shaping the Future',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scholar LMS invites educators, students, and parents to join us in shaping the future of education. Whether you are a part of a traditional classroom setting or engaged in remote learning, our platform is designed to meet your needs and exceed your expectations.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Experience the Power of Education Technology',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'With Scholar LMS, you have the opportunity to experience the power of education technology. Our platform breaks down barriers, fosters collaboration, and opens new doors for learning. Join us on this exciting journey as we build a brighter future for education in Zambia and beyond.',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'For inquiries, support, or partnership opportunities, please feel free to contact us at:',
                      ),
                      Text(
                        'Email: info@scholarlms.com',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        'Phone: +260 962 407 441',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Follow Us on Social Media',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.facebook),
                            onPressed: () {
                              // Handle Facebook link
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.email),
                            onPressed: () {
                              // Handle Twitter link
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
