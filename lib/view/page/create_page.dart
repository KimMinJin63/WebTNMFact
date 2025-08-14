import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});
  static const String route = '/create'; // 페이지 라우트 이름

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text('제목'),  
            SizedBox(height: 8.h),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 16.h),
            Text('내용'),
            SizedBox(height: 8.h),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '내용을 입력하세요',
              ),
            ),
            SizedBox(height: 16.h),
            Text('카테고리'),
            DropdownButton<String>(
              items: <String>['데일리팩트', '인사이트팩트']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
              hint: Text('카테고리를 선택하세요'),
            ),
            SizedBox(height: 16.h),
            Text('태그'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '태그를 입력하세요 (쉼표로 구분)',
              ),
            ),
            SizedBox(height: 16.h),
            Text('이미지 업로드'),  
            ElevatedButton(
              onPressed: () {
                // 글 작성 로직 추가
                print('글 작성 버튼 클릭됨');
              },
              child: const Text('글 작성하기'),
            ),
          ],  
        ),
      )
    );
  }
}