import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Editscreen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusnote = FocusNode();
  final _descriptionNode = FocusNode();
  final _imguUrlController = TextEditingController();
  final _imgUrlfocusnode = FocusNode();
  final _forms = GlobalKey<FormState>();
  var _isloadedpage = false;
  var _editedProducts = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': '',
  };
  var Isinidepent = true;
  @override
  void initState() {
    // TODO: implement initState
    _imgUrlfocusnode.addListener(_updateImg);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final proId = ModalRoute.of(context).settings.arguments as String;
    if (proId != null) {
      _editedProducts = Provider.of<Products>(context).findById(proId);
      Isinidepent = false;
      initValues = {
        'title': _editedProducts.title,
        'description': _editedProducts.description,
        'price': _editedProducts.price.toString(),
        'imgUrl': '',
      };
      _imguUrlController.text = _editedProducts.imageUrl;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imgUrlfocusnode.removeListener(_updateImg);
    _priceFocusnote.dispose();
    _descriptionNode.dispose();

    _imgUrlfocusnode.dispose();
    super.dispose();
  }

  void _updateImg() {
    if (!_imgUrlfocusnode.hasFocus) {
      if (_imguUrlController.text.isEmpty ||
          (!_imguUrlController.text.startsWith('http') &&
              !_imguUrlController.text.startsWith('https')) ||
          (!_imguUrlController.text.endsWith('.png') &&
              !_imguUrlController.text.endsWith('.jpg') &&
              !_imguUrlController.text.endsWith('.jpng'))) {
        return null;
      }
      setState(() {});
    }
  }

  Future<void> _saveForms() async {
    final _validData = _forms.currentState.validate();
    if (!_validData) {
      return;
    }
    _forms.currentState.save();
    setState(() {
      _isloadedpage = true;
    });
    if (_editedProducts.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProducts.id, _editedProducts);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProducts);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('an error occured'),
                  content: Text('something is error'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('okay'))
                  ],
                ));
      }
      // finally{
// Navigator.of(context).pop();
      //  setState(() {
      //   _isloadedpage = false;
      //   });
      //  }
      setState(() {
        _isloadedpage = false;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForms,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isloadedpage
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _forms,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusnote);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please provide data';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                              title: value,
                              id: _editedProducts.id,
                              isFavourite: _editedProducts.isFavourite,
                              price: _editedProducts.price,
                              description: _editedProducts.description,
                              imageUrl: _editedProducts.imageUrl);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusnote,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'add some prices';
                          }
                          if (double.tryParse(value) == null) {
                            return 'try to add some valid num';
                          }
                          if (double.parse(value) <= 0) {
                            return 'avoid below zero values';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                            title: _editedProducts.title,
                            price: double.parse(value),
                            description: _editedProducts.description,
                            imageUrl: _editedProducts.imageUrl,
                            id: _editedProducts.id,
                            isFavourite: _editedProducts.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusnote);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'add some discription';
                          }
                          if (value.length <= 10) {
                            return 'minimum 10 letter req';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                              title: _editedProducts.title,
                              id: _editedProducts.id,
                              isFavourite: _editedProducts.isFavourite,
                              price: _editedProducts.price,
                              description: value,
                              imageUrl: _editedProducts.imageUrl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            padding:
                                EdgeInsets.only(top: 1, right: 2, bottom: 2),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.grey)),
                            child: FittedBox(
                              child: _imguUrlController.text.isEmpty
                                  ? Text('no Url')
                                  : Image.network(
                                      _imguUrlController.text,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _imguUrlController,
                              decoration: InputDecoration(labelText: 'ImgUrl'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imgUrlfocusnode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'enter some url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'enter valid url';
                                }
                                if (value.endsWith('.jpg') &&
                                    value.endsWith('.jpng') &&
                                    value.endsWith('.png')) {
                                  return 'enter valid urls';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForms();
                              },
                              onSaved: (value) {
                                _editedProducts = Product(
                                  title: _editedProducts.title,
                                  id: _editedProducts.id,
                                  isFavourite: _editedProducts.isFavourite,
                                  price: _editedProducts.price,
                                  description: _editedProducts.description,
                                  imageUrl: value,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
