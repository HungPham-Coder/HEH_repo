import 'package:flutter/material.dart';

class MenuListView extends StatelessWidget {
  const MenuListView({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfff5f6f9)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: press,
          child: Row(
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 60,
                height: 60,
              ),
              const SizedBox(
                width: 20,
                height: 10,
              ),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              )),
              const Icon(Icons.arrow_forward_sharp),
            ],
          )),
    );
  }
}

class ResourceListView extends StatelessWidget {
  const ResourceListView({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 230, 232, 235)),
            // padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.black)),
            )),
        onPressed: press,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                height: 200,
                // width: 200,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterMenu extends StatelessWidget {
  RegisterMenu({
    Key? key,
    required this.name,
    required this.time,
    required this.amount,
    required this.icon,
    required this.press,
    required this.full,
    required this.choose,
  }) : super(key: key);

  final String icon, name, time, amount, full;
  final VoidCallback? press;
  bool choose;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 46, 161, 226),
                              width: 2)),
                    )),
                onPressed: press,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      icon,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                      width: 40,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            Text(
                              time,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              amount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 5),
                            Visibility(
                              visible: choose,
                              child: Text(
                                full,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ScheduleMenu extends StatelessWidget {
  ScheduleMenu({
    Key? key,
    required this.name,
    required this.time,
    required this.icon,
    required this.press,
    this.typeOfSlot,
  }) : super(key: key);

  final String icon, name, time;
  final String? typeOfSlot;

  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 46, 161, 226), width: 2)),
              )),
          onPressed: press,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 40,
                height: 50,
              ),
              const SizedBox(width: 10),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      const SizedBox(height: 5),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text('$typeOfSlot'),
                      const SizedBox(height: 5),
                    ],
                  )),
            ],
          )),
    );
  }
}

class FeatureMenu extends StatelessWidget {
  const FeatureMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfff5f6f9)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: press,
          child: Row(
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 60,
                height: 60,
              ),
              const SizedBox(
                width: 20,
                height: 10,
              ),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              )),
              const Icon(Icons.arrow_forward_sharp),
            ],
          )),
    );
  }
}

class HomeMenu extends StatelessWidget {
  HomeMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfff5f6f9)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: press,
          child: Row(
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 60,
                height: 60,
              ),
              const SizedBox(
                width: 20,
                height: 10,
              ),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              )),
              const Icon(Icons.arrow_forward_sharp),
            ],
          )),
    );
  }
}

class SessionMenu extends StatelessWidget {
  SessionMenu({
    Key? key,
    required this.type,
    required this.icon,
    required this.name,
    required this.time,
    required this.buttonPress,
  }) : super(key: key);

  final String type, icon, name, time;
  final VoidCallback buttonPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 46, 161, 226),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 60,
                height: 60,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
              TextButton(
                  child: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: buttonPress),
            ],
          )),
    );
  }
}

class SessionScheduleMenu extends StatelessWidget {
  SessionScheduleMenu({
    Key? key,
    required this.icon,
    required this.name,
    required this.time,
    required this.buttonPress,
    required this.color,
    required this.visible
  }) : super(key: key);
  Color color;
  final String icon, name, time;
  final VoidCallback buttonPress;
  bool visible;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:  color,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                width: 40,
                height: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
              Visibility(
                visible: visible,
                child: TextButton(
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: buttonPress),
              ),
            ],
          )),
    );
  }
}

class PhysioChooseMenu extends StatelessWidget {
  const PhysioChooseMenu({
    Key? key,
    required this.time,
    required this.name,
    required this.icon,
    required this.press,
    required this.slotName,
  }) : super(key: key);

  final String icon, name, time, slotName;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 46, 161, 226),
                            width: 2)),
                  )),
              onPressed: press,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    icon,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    width: 40,
                    height: 50,
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chuyên viên: $name',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          // Text(
                          //   'Khung giờ: $slotName',
                          //   style: Theme.of(context).textTheme.bodyText1,
                          // ),
                          const SizedBox(height: 10),
                          Text(
                            time,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
