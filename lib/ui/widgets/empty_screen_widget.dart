import 'package:flutter/material.dart';

// TODO: add flutter_svg package to pubspec.yaml
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photomall_flutter/color_constants.dart';

class EmptyNotificationsScreen extends StatelessWidget {
  const EmptyNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    noResultsIllustration,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Empty Notifications",
                description:
                    "It looks like you don't have any notifications right now. We'll let you know when there's something new.",
                // button: you can pass your custom button,
                btnText: "Check again",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColorData.appBarTextColor),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColorData.cardHighlightedTextColour),
            ),
            const SizedBox(height: 16 * 2.5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: button ??
                  ElevatedButton(
                    onPressed: press,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor:
                            AppColorData.buttonBackgroundColors.first,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)))),
                    child: Text(
                      btnText ?? "Retry".toUpperCase(),
                      style: TextStyle(color: AppColorData.buttonTextColors),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

const noNotificationIllustration = '''
<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M823.7 629.49C845.367 628.317 867.13 627.02 888.99 625.6" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M270.59 630.37C275.37 605.51 297.8 590.76 329.32 590.76C330.653 590.76 331.957 590.787 333.23 590.84L328.48 633.63L270.59 630.37Z" fill="#ABABAB"/>
<path d="M181 625.6C311 635.293 445.63 639.263 584.89 637.51" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M827.45 706.11C848.26 706.11 868.82 706.11 888.98 706.03" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M181 736.4C229.46 708.72 393.36 704.65 578.41 704.9" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M373 707.89C338.16 723.643 315.627 739.393 305.4 755.14" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M404.2 707.61C369.93 720.47 343.56 737.61 339.2 767.11" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M552.71 538.26C562.413 534.954 570.946 528.899 577.27 520.832C583.595 512.764 587.438 503.033 588.333 492.822C589.227 482.61 587.135 472.359 582.31 463.315C577.484 454.271 570.135 446.824 561.155 441.881C552.175 436.938 541.951 434.711 531.729 435.472C521.507 436.233 511.726 439.949 503.577 446.167C495.427 452.385 489.261 460.838 485.828 470.496C482.395 480.155 481.843 490.603 484.24 500.57C512.9 509.66 537.72 521 552.71 538.26Z" fill="#ABABAB"/>
<path d="M328.48 634C332.57 541.4 372.72 478.56 475.88 499C554.71 517.43 584.88 562 584.88 637.86" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M460.08 495.79C456.544 480.027 457.667 463.577 463.312 448.441C468.958 433.305 478.882 420.137 491.876 410.54C504.871 400.943 520.375 395.331 536.502 394.387C552.629 393.443 568.682 397.208 582.707 405.224C596.733 413.24 608.125 425.16 615.498 439.534C622.87 453.908 625.905 470.115 624.232 486.182C622.559 502.25 616.25 517.484 606.075 530.031C595.899 542.578 582.296 551.896 566.92 556.85" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M215.23 628C218.555 615.278 224.533 603.403 232.771 593.153C241.009 582.904 251.321 574.513 263.03 568.53C274.739 562.546 287.582 559.107 300.714 558.436C313.846 557.766 326.972 559.88 339.23 564.64" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M616 537.66C738.34 483.2 826.26 519.61 840.47 637.75C846.47 685.67 845.04 728.28 840.47 774.75C835.25 798.4 777 795.62 767.78 774.75C762.46 768.88 762.18 709.75 767.78 686.69C768.33 684.42 764.85 683.21 763.06 684.81C746.88 699.31 701.53 699.51 683.25 683.46C682.858 683.116 682.377 682.888 681.863 682.803C681.348 682.717 680.82 682.777 680.337 682.975C679.855 683.174 679.438 683.503 679.132 683.927C678.827 684.35 678.646 684.85 678.61 685.37C682.89 716.67 683.61 746.86 677.03 774.76C669.52 804.01 605.03 801.12 601.94 774.76C595.15 741.76 603.79 679.21 601.94 637.94C595.46 597.83 600.63 564.6 616 537.66Z" fill="#D3D3D3"/>
<path d="M599 537.66C721.34 483.2 809.26 519.61 823.47 637.75C829.47 685.67 828.04 728.28 823.47 774.75C818.25 798.4 760 795.62 750.78 774.75C745.46 768.88 745.18 709.75 750.78 686.69C751.33 684.42 747.85 683.21 746.06 684.81C729.88 699.31 684.53 699.51 666.25 683.46C665.858 683.116 665.377 682.888 664.863 682.803C664.348 682.717 663.82 682.777 663.337 682.975C662.855 683.174 662.437 683.503 662.132 683.927C661.827 684.35 661.646 684.85 661.61 685.37C665.89 716.67 666.61 746.86 660.03 774.76C652.52 804.01 588.03 801.12 584.94 774.76C574.55 738.31 577.08 673.19 584.94 637.94" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M503.87 705.89C497.73 727.08 497.3 756.44 503.87 771.06C511.68 796.32 572.36 795.63 583.87 771.06" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M688.66 706.31C682.52 728.31 683.26 752.64 688.66 773.8C694.72 794.11 741.72 788.28 749.3 772.33" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M494.25 553.29C490.917 567.337 481.25 574.313 465.25 574.22" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M409.34 606.22C403.64 619.48 392.897 624.667 377.11 621.78" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M450.67 636.78L436.12 615.65C431.86 610.74 433.74 602.07 440.31 596.37C446.87 590.67 455.72 590.02 459.98 594.93L487.46 620.55C491.02 624.65 486.86 631.62 481.57 637.13" fill="#0E0E0E"/>
<path d="M516.31 631.74L508.95 637.06" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M239.38 657.85H377.11" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M353.02 671.04H471.27" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M488.79 657.85H520.41" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M688.105 445.974C688.581 445.974 688.947 446.102 689.204 446.358C689.46 446.615 689.588 446.944 689.588 447.347C689.588 447.75 689.442 448.079 689.149 448.336C688.892 448.592 688.545 448.72 688.105 448.72H668.554C668.005 448.72 667.565 448.574 667.236 448.281C666.943 447.988 666.796 447.622 666.796 447.182C666.796 446.67 666.979 446.212 667.346 445.809L684.59 424.775H668.224C667.785 424.775 667.437 424.665 667.181 424.445C666.924 424.189 666.796 423.86 666.796 423.457C666.796 423.054 666.924 422.725 667.181 422.468C667.437 422.212 667.785 422.084 668.224 422.084H687.227C687.776 422.084 688.215 422.23 688.545 422.523C688.874 422.816 689.039 423.182 689.039 423.622C689.039 424.098 688.856 424.537 688.49 424.94L671.245 445.974H688.105Z" fill="#0E0E0E"/>
<path d="M745.633 397.893C746.267 397.893 746.754 398.064 747.096 398.405C747.437 398.746 747.608 399.185 747.608 399.721C747.608 400.258 747.413 400.697 747.023 401.038C746.681 401.379 746.218 401.55 745.633 401.55H719.595C718.864 401.55 718.279 401.355 717.84 400.965C717.45 400.575 717.255 400.087 717.255 399.502C717.255 398.819 717.498 398.21 717.986 397.674L740.952 369.661H719.156C718.571 369.661 718.108 369.515 717.767 369.222C717.425 368.881 717.255 368.442 717.255 367.906C717.255 367.369 717.425 366.93 717.767 366.589C718.108 366.248 718.571 366.077 719.156 366.077H744.463C745.194 366.077 745.779 366.272 746.218 366.662C746.657 367.052 746.876 367.54 746.876 368.125C746.876 368.759 746.632 369.344 746.145 369.88L723.179 397.893H745.633Z" fill="#0E0E0E"/>
<path d="M802.206 339.88C802.891 339.88 803.417 340.064 803.786 340.433C804.155 340.802 804.339 341.276 804.339 341.855C804.339 342.434 804.128 342.908 803.707 343.277C803.338 343.646 802.838 343.83 802.206 343.83H774.082C773.292 343.83 772.66 343.619 772.186 343.198C771.765 342.777 771.554 342.25 771.554 341.618C771.554 340.881 771.817 340.222 772.344 339.643L797.15 309.386H773.608C772.976 309.386 772.476 309.228 772.107 308.912C771.738 308.543 771.554 308.069 771.554 307.49C771.554 306.911 771.738 306.437 772.107 306.068C772.476 305.699 772.976 305.515 773.608 305.515H800.942C801.732 305.515 802.364 305.726 802.838 306.147C803.312 306.568 803.549 307.095 803.549 307.727C803.549 308.412 803.286 309.044 802.759 309.623L777.953 339.88H802.206Z" fill="#0E0E0E"/>
<path d="M680.77 704.89L747.94 705.89" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';
const noResultsIllustration = '''
<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M235.81 752.37H546.81V829.6C546.807 833.153 545.395 836.56 542.882 839.072C540.37 841.585 536.963 842.997 533.41 843H235.81V752.37Z" fill="#BCBCBC"/>
<path d="M200.57 347.31H235.67C237.593 347.31 239.437 348.074 240.797 349.434C242.156 350.793 242.92 352.637 242.92 354.56V835.75C242.92 837.673 242.156 839.517 240.797 840.877C239.437 842.236 237.593 843 235.67 843H207.67C203.867 843 200.219 841.489 197.53 838.8C194.841 836.111 193.33 832.463 193.33 828.66V354.57C193.329 353.618 193.515 352.675 193.878 351.795C194.241 350.915 194.774 350.115 195.446 349.441C196.119 348.766 196.917 348.231 197.796 347.866C198.676 347.5 199.618 347.311 200.57 347.31Z" fill="#BCBCBC"/>
<path d="M528.06 752.37V807.08C528.055 809.662 527.027 812.136 525.201 813.961C523.376 815.787 520.902 816.815 518.32 816.82H177.21C174.628 816.815 172.154 815.787 170.329 813.961C168.503 812.136 167.475 809.662 167.47 807.08V330.75C167.475 328.168 168.503 325.694 170.329 323.869C172.154 322.043 174.628 321.015 177.21 321.01H242.92" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M892.69 687.85L625.76 603.24C634.684 588.385 641.681 572.453 646.58 555.83L908.58 635.53C910.867 636.241 912.78 637.826 913.904 639.94C915.028 642.054 915.271 644.527 914.58 646.82L903.93 681.82C903.225 684.101 901.651 686.012 899.547 687.141C897.443 688.27 894.98 688.524 892.69 687.85Z" fill="#BCBCBC"/>
<path d="M530.38 261.99L622.05 353.67H530.38V261.99Z" fill="#BCBCBC"/>
<path d="M603.5 632V750C603.497 750.633 603.245 751.239 602.797 751.687C602.349 752.135 601.743 752.387 601.11 752.39H245.31C244.677 752.387 244.07 752.135 243.623 751.687C243.175 751.239 242.923 750.633 242.92 750V259C242.923 258.367 243.175 257.76 243.623 257.313C244.07 256.865 244.677 256.612 245.31 256.61H511.82" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M603.5 348.25V404" stroke="#231F20" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M511.82 256.57L603.5 348.25H511.82V256.57Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M492.14 675.92C579.644 675.92 650.58 604.984 650.58 517.48C650.58 429.976 579.644 359.04 492.14 359.04C404.636 359.04 333.7 429.976 333.7 517.48C333.7 604.984 404.636 675.92 492.14 675.92Z" fill="#BCBCBC"/>
<path d="M492.14 675.92C579.644 675.92 650.58 604.984 650.58 517.48C650.58 429.976 579.644 359.04 492.14 359.04C404.636 359.04 333.7 429.976 333.7 517.48C333.7 604.984 404.636 675.92 492.14 675.92Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M492.14 646.47C563.379 646.47 621.13 588.719 621.13 517.48C621.13 446.241 563.379 388.49 492.14 388.49C420.901 388.49 363.15 446.241 363.15 517.48C363.15 588.719 420.901 646.47 492.14 646.47Z" fill="#F4F4F4"/>
<path d="M492.14 646.47C563.379 646.47 621.13 588.719 621.13 517.48C621.13 446.241 563.379 388.49 492.14 388.49C420.901 388.49 363.15 446.241 363.15 517.48C363.15 588.719 420.901 646.47 492.14 646.47Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M896.69 672.85L632.5 593.15C640.67 575.87 646.84 558.42 649.37 539.63L912.6 620.54C914.887 621.25 916.8 622.835 917.924 624.95C919.048 627.064 919.291 629.537 918.6 631.83L907.95 666.83C907.243 669.113 905.665 671.026 903.557 672.153C901.449 673.28 898.981 673.531 896.69 672.85V672.85Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M457.2 530.38C468.693 530.38 478.01 521.063 478.01 509.57C478.01 498.077 468.693 488.76 457.2 488.76C445.707 488.76 436.39 498.077 436.39 509.57C436.39 521.063 445.707 530.38 457.2 530.38Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M457.2 524.86C465.644 524.86 472.49 518.014 472.49 509.57C472.49 501.126 465.644 494.28 457.2 494.28C448.755 494.28 441.91 501.126 441.91 509.57C441.91 518.014 448.755 524.86 457.2 524.86Z" fill="#0E0E0E"/>
<path d="M464.08 505.73C465.582 505.73 466.8 504.512 466.8 503.01C466.8 501.508 465.582 500.29 464.08 500.29C462.578 500.29 461.36 501.508 461.36 503.01C461.36 504.512 462.578 505.73 464.08 505.73Z" fill="white"/>
<path d="M560.93 530.38C572.423 530.38 581.74 521.063 581.74 509.57C581.74 498.077 572.423 488.76 560.93 488.76C549.437 488.76 540.12 498.077 540.12 509.57C540.12 521.063 549.437 530.38 560.93 530.38Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M560.93 524.86C569.375 524.86 576.22 518.014 576.22 509.57C576.22 501.126 569.375 494.28 560.93 494.28C552.486 494.28 545.64 501.126 545.64 509.57C545.64 518.014 552.486 524.86 560.93 524.86Z" fill="#0E0E0E"/>
<path d="M564.93 505.73C566.432 505.73 567.65 504.512 567.65 503.01C567.65 501.508 566.432 500.29 564.93 500.29C563.428 500.29 562.21 501.508 562.21 503.01C562.21 504.512 563.428 505.73 564.93 505.73Z" fill="white"/>
<path d="M473.73 594.73C499.13 575.95 524.53 575.95 549.93 594.73" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M418 480C442.21 474.49 459.07 467.53 466.26 458.64" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M551.61 461.78C572.61 475.03 589.45 482.05 600.82 480.86" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M395.84 485.46L384.84 508.97C378.09 532.39 413.62 530.97 406.51 508.97L395.84 485.46Z" fill="#BCBCBC"/>
<path d="M391.45 482.74L380.45 506.25C373.7 529.67 409.23 528.25 402.12 506.25L391.45 482.74Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 294H436.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 326.52H361.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 359.05H393.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 721H391.31" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 687H329.85" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';