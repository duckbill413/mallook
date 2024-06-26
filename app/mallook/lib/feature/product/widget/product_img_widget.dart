import 'package:flutter/material.dart';
import 'package:mallook/constants/sizes.dart';

class ProductImgWidget extends StatefulWidget {
  final List<String> images;

  const ProductImgWidget({
    super.key,
    required this.images,
  });

  @override
  State<ProductImgWidget> createState() => _ProductImgWidgetState();
}

class _ProductImgWidgetState extends State<ProductImgWidget> {
  final PageController _imageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.size10,
        left: Sizes.size24,
        right: Sizes.size24,
        bottom: Sizes.size6,
      ),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(
                Sizes.size20,
              ),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  PageView.builder(
                    controller: _imageController,
                    itemBuilder: (context, index) => Image.network(
                      filterQuality: FilterQuality.high,
                      widget.images[index], // TODO: 상품 이미지 리스트
                      fit: BoxFit.cover,
                    ),
                    itemCount: widget.images.length,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPageIndex = value;
                      });
                    },
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     vertical: Sizes.size4,
                  //     horizontal: Sizes.size12,
                  //   ),
                  //   margin: const EdgeInsets.all(
                  //     Sizes.size10,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black.withOpacity(0.8),
                  //     borderRadius: BorderRadius.circular(Sizes.size52),
                  //   ),
                  //   child: Text(
                  //     '${_currentPageIndex + 1}/${widget.images.length}',
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Gaps.v6,
          // Container(
          //   height: Sizes.size24,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: Sizes.size32,
          //   ),
          //   child: SmoothPageIndicator(
          //     controller: _imageController,
          //     count: widget.images.length,
          //     effect: ScrollingDotsEffect(
          //       dotHeight: Sizes.size12,
          //       dotWidth: Sizes.size12,
          //       activeDotScale: 1.4,
          //       dotColor: Theme.of(context).primaryColorLight,
          //       activeDotColor: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
