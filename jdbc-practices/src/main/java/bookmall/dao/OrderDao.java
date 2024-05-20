package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;
import bookmall.vo.UserVo;

public class OrderDao {
	private Connection getConnection() throws SQLException {
		Connection conn = null;

		try {
			Class.forName("org.mariadb.jdbc.Driver");

			String url = "jdbc:mariadb://192.168.64.3:3306/bookmall?charset=utf8";
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		}

		return conn;
	}

	public int insert(OrderVo vo) {
		int result = 0;

		try (Connection conn = getConnection();
				PreparedStatement pstmt1 = conn
						.prepareStatement("insert into orders(number, status, payment, shipping, user_no) values (?, ?, ?, ?, ?)");
				PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");) {
			pstmt1.setString(1, vo.getNumber());
			pstmt1.setString(2, vo.getStatus());
			pstmt1.setInt(3, vo.getPayment());
			pstmt1.setString(4, vo.getShipping());
			pstmt1.setLong(5, vo.getUserNo());
			
			result = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			vo.setNo(rs.next() ? rs.getLong(1) : null);
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}

		return result;
	}

	public int insertBook(OrderBookVo vo) {
		int result = 0;

		try (Connection conn = getConnection();
				PreparedStatement pstmt = conn
						.prepareStatement("insert into orders_book(orders_no, book_no, quantity, price) values (?, ?, ?, ?)");
		) {
			pstmt.setLong(1, vo.getOrderNo());
			pstmt.setLong(2, vo.getBookNo());
			pstmt.setInt(3, vo.getQuantity());
			pstmt.setInt(4, vo.getPrice());
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}

		return result;
	}

	public OrderVo findByNoAndUserNo(Long orderNo, Long userNo) {
		OrderVo result = null;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select no, number, status, payment, shipping, user_no from orders where no = ? and user_no = ?");
		) {
			pstmt.setLong(1, orderNo);
			pstmt.setLong(2, userNo);
			
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				Long no = rs.getLong(1);
				String number = rs.getString(2);
				String status = rs.getString(3);
				Integer payment = rs.getInt(4);
				String shipping = rs.getString(5);
				Long rsUserNo = rs.getLong(6);

				OrderVo vo = new OrderVo();
				vo.setNo(no);
				vo.setNumber(number);
				vo.setStatus(status);
				vo.setPayment(payment);
				vo.setShipping(shipping);
				vo.setUserNo(rsUserNo);
				
				result = vo;
			}
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}

		return result;
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long ordersNo, Long userNo) {
		List<OrderBookVo> result = new ArrayList<>();

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select a.orders_no, a.book_no, c.title, a.quantity, a.price from orders_book a join orders b on a.orders_no = b.no join book c on a.book_no = c.no where b.no = ? and b.user_no = ?");
		) {
			pstmt.setLong(1, ordersNo);
			pstmt.setLong(2, userNo);
			
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				Long rsOrderNo = rs.getLong(1);
				Long bookNo = rs.getLong(2);
				String title = rs.getString(3);
				Integer quantity = rs.getInt(4);
				Integer price = rs.getInt(5);
				
				OrderBookVo vo = new OrderBookVo();
				vo.setOrderNo(rsOrderNo);
				vo.setBookNo(bookNo);
				vo.setBookTitle(title);
				vo.setQuantity(quantity);
				vo.setPrice(price);
				
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}

		return result;
	}

	public int deleteBooksByNo(Long ordersNo) {
		int result = 0;
		
		try (
				Connection conn = getConnection();
				PreparedStatement pstmt = conn.prepareStatement("delete from orders_book where orders_no = ?");
		) {
			pstmt.setLong(1, ordersNo);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}
		
		return result;
	}

	public int deleteByNo(Long no) {
		int result = 0;
		
		try (
				Connection conn = getConnection();
				PreparedStatement pstmt = conn.prepareStatement("delete from orders where no = ?");
		) {
			pstmt.setLong(1, no);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error : " + e);
		}
		
		return result;
	}
}
