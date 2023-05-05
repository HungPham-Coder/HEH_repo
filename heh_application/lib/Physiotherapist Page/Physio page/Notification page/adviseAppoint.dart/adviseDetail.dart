import 'package:flutter/material.dart';

class AdviseDetailPage extends StatefulWidget {
  const AdviseDetailPage({Key? key}) : super(key: key);

  @override
  State<AdviseDetailPage> createState() => _AdviseDetailPageState();
}

class _AdviseDetailPageState extends State<AdviseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Xem chi tiết người đặt",
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(children: [
                      const SizedBox(height: 10),
                      const CircleAvatar(
                        maxRadius: 40,
                        backgroundColor: Color.fromARGB(255, 220, 220, 220),
                        backgroundImage: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fperson.png?alt=media&token=c5c521dc-2f27-4fb9-ba76-b0241c2dfe19"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                                child: Text("Thông tin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))),
                            const SizedBox(height: 20),
                            information(
                                name: "Tên người đặt: ", info: "Nguyễn Văn B"),
                            padding(),
                            information(
                                name: "Tên người được điều trị: ",
                                info: "Nguyễn Văn C"),
                            padding(),
                            information(
                                name: "Buổi điều trị: ", info: "Buổi ABC"),
                            padding(),
                            information(
                                name: "Ngày điều trị: ", info: "08-11-2023"),
                            padding(),
                            information(
                                name: "Thời gian bắt đầu: ", info: "11:30"),
                            padding(),
                            information(
                                name: "Thời gian kết thúc: ", info: "12:30"),
                            padding(),
                            information(name: "Tình trạng: ", info: "Đau lưng"),
                            padding(),
                            information(
                                name: "Hoạt động khó khăn: ", info: "Bị A"),
                            padding(),
                            information(
                                name: "Chấn thương: ", info: "Chân thương A"),
                            padding(),
                            information(name: "Bệnh lý: ", info: "Bệnh A"),
                            padding(),
                            information(
                                name: "Thuốc đang sử dụng: ",
                                info: "Thuốc A"),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class information extends StatelessWidget {
  information({Key? key, required this.name, required this.info})
      : super(key: key);
  String name, info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Stack(
        children: [
          Wrap(
            children: [
              Text(name),
              Text(info, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget padding() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Container(
      height: 1,
      color: Colors.grey,
    ),
  );
}
