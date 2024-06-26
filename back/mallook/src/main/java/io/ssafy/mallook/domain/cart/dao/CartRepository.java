package io.ssafy.mallook.domain.cart.dao;

import io.ssafy.mallook.domain.cart.dto.response.CartDetailRes;
import io.ssafy.mallook.domain.cart.entity.Cart;
import io.ssafy.mallook.domain.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CartRepository extends JpaRepository<Cart, Long> {

    @Query(
            """
                    select new io.ssafy.mallook.domain.cart.dto.response.CartDetailRes(
                        c.id, cp.id, cp.product, cp.productPrice, cp.productCount, cp.productName, cp.productImage, cp.productSize, cp.productColor, cp.productFee
                    )
                    from Cart c
                    join CartProduct cp on cp.cart.id = c.id
                    where c.member.id = :memberId
                    order by cp.id
                    """
    )
    List<CartDetailRes> findProductsInCart(@Param("memberId") UUID memberId);

    Optional<Cart> findMyCartByMember(Member member);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query(
            """
                    update Cart c
                    set c.status = false
                    where c.member.id = :memberId
                    """)
    void deleteMyCart(@Param("memberId") UUID memberId);
}
