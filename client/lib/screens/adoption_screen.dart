import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/back_to_home.dart';
import 'package:found_adoption_application/custom_widget/manage_pet_center/all_pet.dart';
import 'package:found_adoption_application/custom_widget/quick_infor.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/filter_dialog.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class AdoptionScreen extends StatefulWidget {
  final centerId;

  const AdoptionScreen({super.key, required this.centerId});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen>
    with AutomaticKeepAliveClientMixin {
  var centerId;
  late var currentClient;
  bool isLoading = true;
  late List<Pet> animals = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  List<Pet> _searchResults = [];
  List<Pet>? _filterResults;
  
  int _currentTabIndex = 0;

  Map<String, List<Pet>?> _filterResultsByTab = {
    'all': null,
    'forSale': null,
    'pending': null,
    'sold': null,
  };

  //Provider
  @override
  bool get wantKeepAlive => true;
  late List<Pet> previousPets = []; // Dữ liệu của pets trước đó
  late bool dataFetched =
      false; // Biến trạng thái để kiểm tra liệu dữ liệu đã được fetch hay chưa

  Future<void> fetchPets() async {
    try {
      var temp = await getCurrentClient();
      setState(() {
        currentClient = temp;
        isLoading = false;
      });

      var pets = await getAllPet();
      if (!listEquals(pets, previousPets)) {
        // Nếu dữ liệu mới khác dữ liệu trước đó, cập nhật dữ liệu trước đó và hiển thị dữ liệu mới
        setState(() {
          previousPets = List.from(pets);
          animals = List.from(pets);
          dataFetched =
              true; // Đặt biến trạng thái thành true sau khi dữ liệu đã được fetch
        });
      }
    } catch (error) {}
  }
  void _updateCurrentTabIndex(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    centerId = widget.centerId;
    fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Builder(builder: (BuildContext context) {
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 60),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TBackHomePage(),
                                    TuserQuickInfor(
                                        currentClient: currentClient),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(currentClient.avatar),
                                    ),
                                  ],
                                ),
                              ),
                              if (currentClient.role == 'USER') buildSearch(),
                            ],
                          ),
                        ]),
                      ),
                    )
                  ];
                },
                body:
                    //Truy cập là CENTER
                    currentClient.role == 'CENTER'
                        ? DefaultTabController(
                            length: 4,
                            child: Stack(children: [
                              Column(
                                children: <Widget>[
                                  ButtonsTabBar(
                                    labelSpacing: 10.0,
                                    backgroundColor: mainColor,
                                    unselectedBackgroundColor: Colors.grey[300],
                                    unselectedLabelStyle:
                                        TextStyle(color: Colors.black),
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    tabs: [
                                      Tab(
                                        icon: Icon(Icons.pets),
                                        text: "Tất cả",
                                      ),
                                      Tab(
                                        icon: Icon(Icons.storefront),
                                        text: "Đang đăng bán",
                                      ),
                                      Tab(
                                        iconMargin: EdgeInsets.only(right: 100),
                                        icon:
                                            Icon(FontAwesomeIcons.cartShopping),
                                        text: "Đang được mua",
                                      ),
                                      Tab(
                                        icon: Icon(Icons.loyalty),
                                        text: "Đã bán",
                                      ),
                                    ],
                                    onTap: (index) {
                                      _updateCurrentTabIndex(index);
                                    },
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: <Widget>[
                                        AllPetCenter(
                                          listType: 'all',
                                          searchKeyword: _searchKeyword,
                                          onSearchKeywordChanged:
                                              _updateSearchKeyword,
                                          filterResult:
                                              _filterResultsByTab['all'],
                                        ),
                                        AllPetCenter(
                                          listType: 'forSale',
                                          searchKeyword: '',
                                          onSearchKeywordChanged:
                                              _updateSearchKeyword,
                                          filterResult:
                                              _filterResultsByTab['forSale'],
                                        ),
                                        AllPetCenter(
                                          listType: 'pending',
                                          searchKeyword: '',
                                          onSearchKeywordChanged:
                                              _updateSearchKeyword,
                                          filterResult:
                                              _filterResultsByTab['pending'],
                                        ),
                                        AllPetCenter(
                                          listType: 'sold',
                                          searchKeyword: '',
                                          onSearchKeywordChanged:
                                              _updateSearchKeyword,
                                          filterResult:
                                              _filterResultsByTab['sold'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 48,
                                right: 10,
                                child: Container(
                                  width: 70,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.sliders),
                                        color: mainColor,
                                        onPressed: () {
                                          showFilterDialog();
                                        },
                                        iconSize: 20,
                                      ),
                                      Text(
                                        'Lọc',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          )

                        //Truy cập là USER

                        : AllPetCenter(
                            listType: 'forSale',
                            searchKeyword: _searchKeyword,
                            onSearchKeywordChanged: _updateSearchKeyword,
                            filterResult: _filterResults,
                          ),
              );
            }),
    );
  }

  Future<void> showFilterDialog() async {
    final result = await showDialog<List<Pet>>(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 0.9,
          alignment: Alignment.center,
          heightFactor: 0.7,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FilterDialog(),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        if(currentClient.role=='CENTER')
        {
          switch (_currentTabIndex) {
          case 0:
            _filterResultsByTab['all'] = result;
            break;
          case 1:
            _filterResultsByTab['forSale'] = result;
            break;
          case 2:
            _filterResultsByTab['pending'] = result;
            break;
          case 3:
            _filterResultsByTab['sold'] = result;
            break;
          default:
            break;
        }
        }
        else{
          _filterResults =result;
        }
      });
    }
  }

  void _updateSearchKeyword(String keyword) {
    setState(() {
      _searchKeyword = keyword;
    });
  }

  Widget buildSearch() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 18, right: 10, top: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.06),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 18),
            width: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.search,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tìm kiếm thú cưng',
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              4), // Giảm khoảng cách giữa các phần tử trong vùng nhập
                    ),
                    onChanged: (value) {
                      _updateSearchKeyword(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.sliders),
                  color: mainColor,
                  onPressed: () {
                    showFilterDialog();
                  },
                  iconSize: 20,
                ),
                Text(
                  'Lọc',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
