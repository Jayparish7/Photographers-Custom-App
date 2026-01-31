import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/studioPackages/listRoute/studio_package_list_view_model.dart';

double getDiscountByPercentage(int discountValue, int price) {
  double _price = (price / 100);
  double _discount = (discountValue / 100);
  double _discountValue = (_price * _discount) / 100;
  double _discountedPrice = (price - _discountValue);
  return _discountedPrice;
}

double getDiscountByAmount(int discountValue, int price) {
  double _price = (price / 100);
  double _discount = (discountValue / 100);
  return (_price - _discount);
}

getAmountDetailedView(
  BuildContext context,
  String? discountedPrice,
  String? discount,
  String actualPrice,
  int? discountedTerm,
) {
  return discount != null
      ? Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  isCard: true,
                  text: "\u{20B9}",
                  style: Theme.of(context).textTheme.bodySmall,
                  // style: TextStyle(fontSize: 12),
                ),
                CommonText(
                  isCard: true,
                  isHighlightedCard: true,
                  text: '${getAmount(discountedPrice!).amount}',
                  //style: TextStyle(fontSize: 18),
                ),
                CommonText(
                  isCard: true,

                  text:
                      "${getAmount(discountedPrice).paisa == '0' ? "00" : getAmount(actualPrice).paisa} ",

                  //style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            CommonText(
              isCard: true,
              isHighlightedCard: false,
              isLined: true,
              text:
                  '\u{20B9} ${getAmount(actualPrice).amount}.${getAmount(actualPrice).paisa == '0' ? '00' : getAmount(actualPrice).paisa}',
              style: TextStyle(
                  fontSize: 12, decoration: TextDecoration.lineThrough),
            ),
            discountedTerm == 1
                ? CommonText(
                    isCard: true,
                    text: ' ${S.of(context).save} ${discount} %',
                    style: Theme.of(context).textTheme.bodySmall,
                    //style: TextStyle(fontSize: 12),
                  )
                : offerAmount(context: context, discount: discount)
            /*CommonText(
                    text: ' save \u{20B9} ${getAmount(discount).amount}.${getAmount(discount).paisa == '0' ? '00' : getAmount(discount).paisa}',
                   // style: TextStyle(fontSize: 12),
              style: Theme.of(context).textTheme.bodySmall,
                  ),*/
          ],
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  isCard: true,
                  text: "\u{20B9}",

                  //style: TextStyle(fontSize: 12),
                ),
                CommonText(
                  isCard: true,
                  isHighlightedCard: true,
                  text: '${getAmount(actualPrice).amount}',
                  // style: TextStyle(fontSize: 18),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                CommonText(
                  isCard: true,

                  text:
                      "${getAmount(actualPrice).paisa == '0' ? '00' : getAmount(actualPrice).paisa} ",
                  //style: TextStyle(fontSize: 12),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            CommonText(
              isCard: true,

              text: S.of(context).only,
              style: Theme.of(context).textTheme.bodySmall,
              //style: TextStyle(fontSize: 12),
            ),
          ],
        );
}

Widget offerAmount({
  required BuildContext context,
  required String discount,
}) {
  return Wrap(
    alignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.end,
    children: [
      CommonText(
        isCard: true,
        text: ' ${S.of(context).save} \u{20B9} ',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      CommonText(
        isCard: true,
        text:
            '${getAmount(discount).amount}.${getAmount(discount).paisa == '0' ? '00' : getAmount(discount).paisa}',
        isBodyHighlightedText: true,
      ),
    ],
  );
}

AmountView getAmount(String amount) {
  var indiaFormat =
      NumberFormat.currency(symbol: "", locale: 'HI', decimalDigits: 0);

  double myDouble = double.parse(amount);
  double fraction = myDouble - myDouble.truncate();
  int pisa = (fraction * 100).truncate();
  int rupees = double.parse(amount).toInt();

  return AmountView(amount: indiaFormat.format(rupees), paisa: pisa.toString());
}
