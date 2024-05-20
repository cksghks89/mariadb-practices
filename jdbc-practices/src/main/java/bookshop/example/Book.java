package bookshop.example;

public class Book {
	private int bookNo;
	private String title;
	private String author;
	private int stateCode;

	public Book(int bookNo, String title, String author) {
		this.bookNo = bookNo;
		this.title = title;
		this.author = author;
		this.stateCode = 1;
	}

	public void rent() {
		this.stateCode = 0;
		System.out.println(this.title + "이(가) 대여 되었습니다.");
	}

	public void print() {
		System.out.printf("책번호 %d, 제목:%s, 작가:%s, 대여유무:%s\n", this.bookNo, this.title, this.author, this.stateCode == 1 ? "재고있음" : "재고없음");
	}

	public int getBookNo() {
		return bookNo;
	}

	public void setBookNo(int bookNo) {
		this.bookNo = bookNo;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getStateCode() {
		return stateCode;
	}

	public void setStateCode(int stateCode) {
		this.stateCode = stateCode;
	}

}
