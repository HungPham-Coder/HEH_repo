import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0;
  final TextEditingController _comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Đánh giá",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              FeedbackListView(
                slotName: "A",
                typeOfSlot: "Loại trị liệu: ",
                date: "Ngày đặt:",
                physiotherapist: "Chuyên viên: ",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FeedbackListView({
    slotName,
    typeOfSlot,
    date,
    physiotherapist,
    required VoidCallback press,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 211, 234, 246),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey, width: 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                slotName,
                style: const TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            feedback(),
            const SizedBox(height: 10),
            Text(
              typeOfSlot,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              physiotherapist,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _comment,
              decoration: const InputDecoration(
                hintText: 'Thêm đánh giá',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey),
                // ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 5),
            Center(
                child: ElevatedButton(
                    onPressed: press,
                    child: const Text(
                      "Gửi đánh giá",
                      style: TextStyle(fontSize: 18),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget feedback() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            updateOnDrag: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              setState(() {
                this.rating = rating;
              });
            },
          ),
          // Text("Đánh giá: ${rating}")
        ],
      ),
    );
  }
}
