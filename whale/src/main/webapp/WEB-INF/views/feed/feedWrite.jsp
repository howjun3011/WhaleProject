<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="write-area">
    <form action="feedWriteDo" method="post" enctype="multipart/form-data">
        <textarea name="feedText" placeholder="Write something..."></textarea>
        <br>
        <input type="file" name="feedImage" accept="image/*">
        <br>
        <button type="submit" class="submit-btn">글 작성</button>
    </form>
</div>