// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/breed_model.dart';
import 'package:found_adoption_application/models/center_hot_model.dart';
import 'package:found_adoption_application/models/pet_sale_model.dart';
import 'package:found_adoption_application/screens/guest/widget.dart';
import 'package:found_adoption_application/services/center/petApi.dart';

class Home_Guest extends StatefulWidget {
  const Home_Guest({super.key});

  @override
  State<Home_Guest> createState() => _Home_GuestState();
}

class _Home_GuestState extends State<Home_Guest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);
  late List<bool> isLoadingFollows = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(95.0),
            child: Stack(
              children: [
                Image(
                    image: AssetImage("assets/images/background_top.png"),
                    fit: BoxFit.fill,
                    height: 150.0,
                    width: double.infinity),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/dog_banner.png"),
                        height: 80.0,
                        width: 80.0,
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chào mừng bạn đến với",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "My pets",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "Ứng dụng mua bán thú cưng tuyệt vời!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CustomScrollView(slivers: [
              BreedFavotite(tabController: _tabController),
              const CenterFavorite(),
              const PetSaleWidget(),
            ])));
  }
}

class PetSaleWidget extends StatelessWidget {
  const PetSaleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Thú cưng được giảm giá",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  //xem tất cả
                },
                child: const Text(
                  "Xem tất cả",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 210.0,
            child: FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.error != null) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<PetSale> listPetSale = [
                      PetSale(
                          id: "123",
                          name: "Chó Alaska",
                          breed: "Alaska",
                          price: 1000000,
                          reducedPrice: 900000,
                          image: 'assets/dogs/alaska.jpg'),
                      PetSale(
                          id: "123",
                          name: "Chó Alaska",
                          breed: "Alaska",
                          price: 1000000,
                          reducedPrice: 900000,
                          image: 'assets/dogs/backinh.jpg'),
                      PetSale(
                          id: "123",
                          name: "Chó Alaska",
                          breed: "Alaska",
                          price: 1000000,
                          reducedPrice: 900000,
                          image: 'assets/dogs/corgi.jpg'),
                      PetSale(
                          id: "123",
                          name: "Chó Alaska",
                          breed: "Alaska",
                          price: 1000000,
                          reducedPrice: 900000,
                          image: 'assets/dogs/alaska.jpg')
                    ];

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              //chuyển sang trang chi tiết
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(children: [
                                  Container(
                                    height: 200.0,
                                    width: 230.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                listPetSale[index].image),
                                            fit: BoxFit.cover)),
                                  ),
                                  Container(
                                    height: 200.0,
                                    width: 230.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                            begin: Alignment.center,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.black.withOpacity(0.9)
                                            ])),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 230,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Text(listPetSale[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Text(
                                                " - ${listPetSale[index].breed}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.fade),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${listPetSale[index].price}đ",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationThickness:
                                                              2.0,
                                                          decorationColor:
                                                              Colors.white)),
                                                  Text(
                                                      "${listPetSale[index].price - listPetSale[index].reducedPrice}đ",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  //
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.teal[300]),
                                                  child: const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ])),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    ));
  }
}

class CenterFavorite extends StatefulWidget {
  const CenterFavorite({
    super.key,
  });

  @override
  State<CenterFavorite> createState() => _CenterFavoriteState();
}

class _CenterFavoriteState extends State<CenterFavorite> {
  Future<List<CenterHot>>? centerHotFuture;

  @override
  void initState() {
    super.initState();
    centerHotFuture = getCenterHot();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Trung tâm được yêu thích",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  //xem tất cả
                },
                child: const Text(
                  "Xem tất cả",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 150.0,
            child: FutureBuilder(
                future: centerHotFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.error != null) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<CenterHot> listCenterHot = snapshot.data as List<CenterHot>;

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              //chuyển sang trang chi tiết
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 140.0,
                                      width: 240.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.blue[100]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            listCenterHot[index]
                                                                .avatar),
                                                        fit: BoxFit.cover)),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 130,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listCenterHot[index].name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          listCenterHot[index]
                                                              .rating
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Icon(
                                                          Icons.shopping_cart,
                                                          color: Colors.black,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          listCenterHot[index]
                                                              .sold
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${listCenterHot[index].sold} người theo dõi",
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          onPressFollow(
                                            follow: listCenterHot[index].follow,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    ));
  }
}

// ignore: must_be_immutable
class onPressFollow extends StatefulWidget {
  late bool follow;
  onPressFollow({
    super.key,
    required this.follow,
  });

  @override
  State<onPressFollow> createState() => _onPressFollowState();
}

class _onPressFollowState extends State<onPressFollow> {
  late bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLoading = true;
          widget.follow = !widget.follow;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        });
      },
      child: Container(
        width: 220,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.teal),
        child: !isLoading
            ? Center(
                child: Text(
                  widget.follow ? "Đang theo dõi" : "Theo dõi",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )
            : const OnPressedButton(
                size: 13,
                strokeWidth: 2.0,
              ),
      ),
    );
  }
}

class BreedFavotite extends StatelessWidget {
  const BreedFavotite({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Thú cưng được yêu thích",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  //xem tất cả
                },
                child: const Text(
                  "Xem tất cả",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 220.0,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Colors.black),
                      insets: EdgeInsets.zero),
                  unselectedLabelColor: Colors.grey,
                  tabs: const <Widget>[
                    Tab(text: 'Chó'),
                    Tab(text: 'Mèo'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      BreedWidget(breedName: "Dog"),
                      BreedWidget(breedName: "Cat"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class BreedWidget extends StatefulWidget {
  final String breedName;
  const BreedWidget({
    super.key,
    required this.breedName,
  });

  @override
  State<BreedWidget> createState() => _BreedWidgetState();
}

class _BreedWidgetState extends State<BreedWidget> {
  Future<List<Breed>>? breedFuture;

  @override
  void initState() {
    breedFuture = getBreed(widget.breedName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: breedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Breed> getBreed = snapshot.data as List<Breed>;

            List<Breed> breeds = Breed.generate(widget.breedName);

            for (var i = 0; i < breeds.length; i++) {
              breeds[i].view = getBreed[i].view;
              breeds[i].sold = getBreed[i].sold;
            }

            //sắp xếp breeds theo số lượng bán được giảm dần nếu bằng thì sắp xếp theo số lượt xem giảm dần
            breeds.sort((a, b) {
              if (a.sold == b.sold) {
                return b.view.compareTo(a.view);
              }
              return b.sold.compareTo(a.sold);
            });

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //chuyển sang trang chi tiết
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: Stack(children: [
                          Image(
                            image: AssetImage(breeds[index].asset),
                            height: 180.0,
                            width: 130.0,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 180.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.8)
                                ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    breeds[index].name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        breeds[index].view.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        breeds[index].sold.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ]),
                          )
                        ]),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
