import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/provider/home_provider.dart';
import 'package:catalinadev/provider/store_provider.dart';
import 'package:catalinadev/provider/wishlist_provider.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/utils/currency_format.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:catalinadev/widget/marquee.dart';
import 'package:catalinadev/widget/widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uiblock/uiblock.dart';

part 'theme.dart';
part 'grid_list.dart';
