import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_place_seller/constant/decoration.dart';
import 'package:market_place_seller/constant/product_type.dart';
import 'package:market_place_seller/models/product_model.dart';
import 'package:market_place_seller/services/product_services.dart';

class AddNewProduct extends StatefulWidget {
  final ProductModel product;
  AddNewProduct({this.product});

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductServices _productServices = ProductServices();
  final ImagePicker _imagePicker = ImagePicker();

  List<PickedFile> _listPickedFile = List<PickedFile>();
  ProductModel productData = ProductModel();
  bool loading = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(value),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      ),
    );
  }

  void selectImage(ImageSource source) async {
    final PickedFile _file = await _imagePicker.getImage(source: source);
    setState(() => _listPickedFile.add(_file));
  }

  void addProduct() async {
    if (_formKey.currentState.validate()) {
      productData.productImages = _productServices.getImageFile(_listPickedFile);
      if (_listPickedFile.isNotEmpty) {
        setState(() => loading = true);
        await _productServices.addNewProduct(productData).catchError(
          (onError) {
            setState(() => loading = false);
            showInSnackBar(onError);
          },
        ).whenComplete(
          () {
            showInSnackBar('Product Add Successfuly!');
            Navigator.pop(context);
            setState(() => loading = false);
          },
        );
      } else {
        showInSnackBar('Please add at lest one photo to your product!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Add New Product',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  addImages(size, context),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: textFaildDecoration,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(hintText: 'Product Name'),
                      validator: (value) => value.isEmpty ? 'Enter Product Name ..' : null,
                      initialValue: widget?.product?.productName ?? '',
                      onChanged: (value) => productData.productName = value,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: textFaildDecoration,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(hintText: 'Price'),
                      validator: (value) => value.isEmpty ? 'Enter Product price ..' : null,
                      initialValue: widget?.product?.price ?? '',
                      onChanged: (value) => productData.price = value,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: textFaildDecoration,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(hintText: 'Quantity'),
                      validator: (value) => value.isEmpty ? 'Enter Product Quantity!' : null,
                      initialValue: widget?.product?.quantity ?? '',
                      onChanged: (value) => productData.quantity = value,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      boxShadow: [shadow],
                    ),
                    child: DropdownButton(
                      hint: Text('Product Type'),
                      isExpanded: true,
                      value: widget?.product?.productType ?? productData.productType,
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.black87, fontSize: 18.0),
                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.green),
                      onChanged: (onChange) => productData.productType = onChange,
                      items: types.map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: textFaildDecoration,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(hintText: 'Description'),
                      validator: (value) => value.isEmpty ? 'Enter Product Description' : null,
                      initialValue: widget?.product?.description ?? '',
                      onChanged: (value) => productData.description = value,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.text,
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: textFaildDecoration,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(hintText: 'Specifications'),
                      validator: (value) =>
                          value.isEmpty ? 'Enter Product Specifications ..' : null,
                      initialValue: widget?.product?.specification ?? '',
                      onChanged: (value) => productData.specification = value,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.text,
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text('Add'),
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                      mouseCursor: MouseCursor.defer,
                      textColor: Colors.white,
                      onPressed: addProduct,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading
            ? Container(
                height: size.height,
                width: size.width,
                color: Colors.black.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(),
      ],
    );
  }

  Container addImages(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Wrap(
          children: _listPickedFile.map<Widget>((image) => viewImage(image, size)).followedBy([
        _listPickedFile.length < 6 ? addImageButton(size, context) : Container(),
      ]).toList()),
    );
  }

  Container viewImage(PickedFile image, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(
          File(image.path),
          width: size.width * 0.3,
          height: size.width * 0.3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget addImageButton(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
      height: size.width * 0.3,
      width: size.width * 0.3,
      child: OutlineButton(
        onPressed: () => selectImage(ImageSource.gallery),
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        child: Icon(Icons.add_a_photo, color: Theme.of(context).accentColor),
      ),
    );
  }

  // updateProduct(double width, BuildContext context) async {
  //   return WidthButton(
  //     title: 'Update',
  //     loading: loading,
  //     width: width,
  //     onTap: () async {
  //       if (images.isEmpty) {
  //         // show the loading screen
  //         setState(() => loading = true);
  //         // start with uploading the images
  //         await uploadImages().then((onComplete) async {
  //           // whene complete add the product data
  //           await productServices.updateNewProduct(
  //             proId: widget.product.productId,
  //             productName: name ?? widget.product.productName,
  //             price: price ?? widget.product.price,
  //             productType: type ?? widget.product.productType,
  //             description: description ?? widget.product.description,
  //             quantity: quantity ?? widget.product.quantity,
  //             specification: specifications ?? widget.product.specification,
  //             productImages: widget.product.productImages,
  //           );

  //           // if an error happened
  //         }).catchError((onError) {
  //           setState(() => loading = false);
  //           showToast(context, 'Something went wrong: $onError');

  //           // when it finshed clear everything and navigate to home
  //         }).whenComplete(() {
  //           setState(() {
  //             loading = false;
  //             name = '';
  //             price = '';
  //             description = '';
  //             quantity = '';
  //             specifications = '';
  //             images.clear();
  //             type = null;
  //           });
  //           showToast(context, 'Product updated Successfuly');

  //           Navigator.pushReplacement(
  //             context,
  //             CupertinoPageRoute(
  //               builder: (context) => Saller(),
  //             ),
  //           );
  //         });
  //       }
  //     },
  //   );
  // }
}
