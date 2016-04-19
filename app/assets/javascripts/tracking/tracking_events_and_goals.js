// first version of tracking events,
// this script should evelute with business decision,
// that code is a proof of concept and fingerprint in that ecommerce data analysis
// beyond this file, there's other files referencing at this code,
// please check application.js and infinite_scroll.js and checkout/review.html.erb
// there is many tracking attributes in html, see eg. data-book-id, data-book-type
// removing theses attributes can happen of lost some tracking behaviors
// @see https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce
// @see https://www.optimizesmart.com/implementing-enhanced-ecommerce-tracking-universal-analytics/

function trackingEvents(){
	try {
				
		// tracking on banner clicks
		$('.feature-item').on('click', function(e){
			var $el = $(this),
				id = $el.data('feature-id'),
				slug = $el.data('feature-slug'),
				position = $el.data('feature-position');

			ga('ec:addPromo', promoFieldObject({
				"id": id,
				"name": slug,
				"position": position
			}));

	  		ga('ec:setAction', 'promo_click');
			ga('send', 'event', 'Loja', 'Clicou no Banner', slug);
		});

		// tracking for banner impressions
		$('body').on('feature:impression', function(e) {
			var $el = $($('.feature-item')[0]);
				id = $el.data('feature-id'),
				slug = $el.data('feature-slug'),
				position = $el.data('feature-position');

			ga('ec:addPromo', promoFieldObject({
				"id": id,
				"name": slug,
				"position": position
			}));

			ga('send', 'event', 'Loja', 'Visualizou o Banner', slug);
		});

		// tracking click on details from related list
		$('.related-list-item').on('click', function(e){
			var $el = $(this);
			var product = fetchProduct($el.data('book-id'))

			var book = {
			  'id': product.id,
	          'name': product.title,
	          'category': product.category,
	          'brand' : product.publisher
	         };

			ga('ec:addProduct', book);
			ga('ec:setAction', 'detail');
			ga('send', 'event', 'Loja', 'Clicou em Detalhes do Produto - '+ product.section_type, book.name + ' - ' + product.isbn);
			ga('send', 'event', 'Livro - ' + product.category, 'Clicou em Detalhes do Produto - ' + product.section_type, book.name + ' - ' + product.isbn);
		});

		// tracking impression for relared list
		$('body').on('related-item:impression', function(e, book_id, position){
			var product = fetchProduct(book_id)

			var book = {
			  'id': product.id,
	          'name': product.title,
	          'category': product.category,
	          'brand' : product.publisher,
	          'position': position
	    	};
	    	ga('ec:addImpression', book);
	    	ga('send', 'event', 'Loja', 'Visualizou o Produto - '+ product.section_type, book.name + ' - ' + product.isbn);
		});
		
		// tracking click on details from list item
		$('.book-list-item .book-title, .book-list-item .item-cover').on('click', function(e){
			var $el = $(this);
			var product = fetchProduct($el.data('book-id'))

			var book = {
			  'id': product.id,
	          'name': product.title,
	          'category': product.category,
	          'brand' : product.publisher
	    	};

			ga('ec:addProduct', book);
			ga('ec:setAction', 'detail');
			ga('send', 'event', 'Loja', 'Clicou em Detalhes do Produto', book.name + ' - ' + product.isbn);
			ga('send', 'event', 'Livro - ' + product.category, 'Clicou em Detalhes do Produto', book.name + ' - ' + product.isbn);
		});

		// tracking impressions for list item
		$('body').on('book-item:impression', function(e, book_id, position){
			var product = fetchProduct(book_id)

			var book = {
			  'id': product.id,
	          'name': product.title,
	          'category': product.category,
	          'brand' : product.publisher,
	          'position': position
	    	};

	    	ga('ec:addImpression', book);
	    	ga('send', 'event', 'Loja', 'Visualizou o Produto', book.name + ' - ' + product.isbn);
		});
		// tracking addToCart actions
		$('.item-price .item-type').on('click', function(e){

			var $el = $(this).find('.price');
			var product = fetchProduct($el.data('book-id'))

			product["id"] = $el.data('book-id');
			product["type"] = $el.data('book-type');
			product["price"] = $el.data('book-price');
			if ($el.data('book-promotion')) product["coupon"] = $el.data('book-promotion');

			var book = {
			  'id': product.id,
	          'name': product.title,
	          'category': product.category,
	          'brand' : product.publisher,
	          'price': product.price,
	          'variant' : product.type,
	          'quantity': 1
	    	};

	    	if (product.coupon) {
	    		book["coupon"] = product.coupon;
	    	}

			ga('ec:addProduct', book);
			ga('ec:setAction', 'add');
			ga('send', 'event', 'Carrinho', 'Adicionou ao Carrinho', book.name + ' - ' + product.isbn);
			ga('send', 'event', 'Livro - ' + product.category, 'Adicionou ao Carrinho', book.name + ' - ' + product.isbn);
			fbq('track', 'AddToCart', book)
		});

		// listen to change in cart, tracking add or remove cart itens
		$('.cart').on('submit', function() {
			$('.cart-item').each(function(){
				$el = $(this);
				var product = fetchProduct($el.data('book-id'));
				product["id"] = $el.data('book-id');
				product["type"] = $el.data('book-type');
				product["price"] = $el.data('book-price');
				if ($el.data('book-promotion')) product["coupon"] = $el.data('book-promotion');
				var book_cart_quantity = product["quantity"] = $el.data('book-quantity');
				var book_input_quantity = $el.find('.book-quantity').val();
				var amount = book_cart_quantity - book_input_quantity;
				var tracking_action = 'remove';
				var tracking_msg = 'Removeu do Carrinho';

				if (amount == 0) return;

				if (parseInt(book_input_quantity) > parseInt(book_cart_quantity)) {
					amount = book_input_quantity - book_cart_quantity;
					tracking_action = 'add';
					tracking_msg = 'Adicionou ao Carrinho';
				}

				var book = {
				  'id': product.id,
	          	  'name': product.title,
	              'category': product.category,
	          	  'brand' : product.publisher,
	          	  'price': product.price,
	          	  'variant' : product.type,
	          	  'quantity': amount
	    		};
	    		if (product.coupon) {
	    		  book["coupon"] = product.coupon;
	    		}	

	    		ga('ec:addProduct', book);
				ga('ec:setAction', tracking_action);
				ga('send', 'event', 'Carrinho', tracking_msg, book.name + ' - ' + product.isbn);
				ga('send', 'event', 'Livro - ' + product.category, tracking_msg, book.name + ' - ' + product.isbn);
			});
		});

		// tracking search 
		$('.search-item').on('submit', function() {
			var searchQuery = $(this).find('.search-query').val();
			ga('send', 'event', 'Loja', 'Executou uma busca', searchQuery);
		});

		// tracking navigation header
		$('#site-header a').on('click', function() {
			var section = $(this).data('store-section');
			ga('send', 'event', 'Loja', 'Navegou para outra seção', section);
		});

		// tracking Cart review, the first step of funnel
		if ($('form.cart').length > 0) {
			trackCheckoutSteps(1, null);
			ga('send', 'event', 'Carrinho', 'Chegou ao Carrinho');
			ga('send', 'event', 'Checkout', 'Chegou ao Carrinho');
		}

		// tracking Registration or Login, the second step of funnel
		// for users which already authenticated
		if ($('#sign_up_or_sign_in form').length == 0 && $('.user_info').length == 1) {
			trackCheckoutSteps(2, 'Usuário Já estava Autenticado');
			ga('send', 'event', 'Checkout', 'Usuário Já estava Autenticado');
		
		}

		// tracking Registration or Login, the second step of funnel
		$('#sign_up_or_sign_in form').on('submit', function() {
			// avoid ga funnel tracking for a just standalone login
			if ($('.standalone').length == 0) {
				var registration_type = 'Logou em uma conta existente';
				if ($(this).attr('id') == 'registration_form') {
					registration_type = 'Criou uma nova conta';
				}
				trackCheckoutSteps(2, registration_type);
				ga('send', 'event', 'Checkout', registration_type);
			}
		});

		// tracking Billing type, the third step of funnel
		$('.payment-type .payment-choose').on('click', function() {
			var payment_type = $(this).attr('id');
			var map_payment_type = {
				link_to_payment_card: 'Cartão de crédito',
				link_to_payment_slip: 'Boleto',
				link_to_payment_paypal: 'Paypal'
			}

			trackCheckoutSteps(3, map_payment_type[payment_type]);
			ga('send', 'event', 'Checkout', 'Informações de Pagamento', map_payment_type[payment_type]);
		});

		$('.recalculate-shipment-cost').on('click', function() {
			trackCheckoutSteps(4, null);
			ga('send', 'event', 'Checkout', 'Endereço de entrega');
		});

		$('.payment-type form').on('submit', function(){
			trackCheckoutSteps(null);

		});

		var watched_el = [
		  {
		  	element: '.related-list-item',
			event: 'related-item:impression',
			data: 'book-id'
		  },
		  {
		  	element: '.book-list-item',
			event: 'book-item:impression',
		   	data: 'book-id'
		  }
		];
		watchElementsImpression(watched_el);
		var watchTimeout = null;
		
		$(document).on('scroll', function(){
			clearTimeout(watchTimeout);
			watchTimeout = setTimeout(function(){
				watchElementsImpression(watched_el)
			}, 3000);
		});

	} catch(e) {
		console.log('Error', e);
	}
}

function fetchProduct(product_id) {
	var $el_attr = $('[data-book-target-id='+product_id+']');
		
	var product = {
		"id" : $el_attr.data('book-id'),
		"isbn": $el_attr.data('book-isbn'),
		"slug": $el_attr.data('book-slug'),
		"title": $el_attr.data('book-title'),
		"author": $el_attr.data('book-author'),
		"category": $el_attr.data('book-category'),
		"publisher": $el_attr.data('book-publisher'),
		"section_type": $el_attr.data('section-type')
	}
	return product;
}

function promoFieldObject(attributes) {
	return {
	  "id": attributes.id,
	  "name": attributes.name,
	  "creative": attributes.creative || null,
	  "position": attributes.position || null
	}
}

// verify if element if visible (on viewport)
// only if visible, trigger event
// example parameters
// {
// 	  	element: '.related-list-item',
// 		event: 'related-item:impression',
// 		data: 'book-id'
// 	  },
function watchElementsImpression(watched_el) {
	if (!jQuery.isArray(watched_el)) watched_el = [watched_el];

	var viewportWidth = jQuery(window).width(),
	 	viewportHeight = jQuery(window).height(),
	 	documentScrollTop = jQuery(document).scrollTop(),
	 	documentScrollLeft = jQuery(document).scrollLeft(),
	 	minTop = documentScrollTop,
	 	maxTop = documentScrollTop + viewportHeight,
	 	minLeft = documentScrollLeft,
	 	maxLeft = documentScrollLeft + viewportWidth;

	 watched_el.forEach(function(map) {
	 	jQuery(map.element).each(function(index, el) {
	 		elementOffset = $(this).offset();
	 		if (
	 			(elementOffset.top > minTop && elementOffset.top < maxTop) &&
	 			(elementOffset.left > minLeft &&elementOffset.left < maxLeft)
	 			) {
	  			$('body').trigger(map.event,[$(this).data(map.data), index]);
	  		}
	 	});
	 }); 
}

// In each checkout step we should send to ga
// all state of cart itens
function trackCheckoutSteps(step, options){
	$('.cart-item').each(function() {
		$el = $(this);
		var product = fetchProduct($el.data('book-id'));
		product["id"] = $el.data('book-id');
		product["type"] = $el.data('book-type');
		product["price"] = $el.data('book-price');
		if ($el.data('book-promotion')) product["coupon"] = $el.data('book-promotion');
		var book_cart_quantity = product["quantity"] = $el.data('book-quantity');
		var book_input_quantity = $el.find('.book-quantity').val();
		var amount = book_cart_quantity - book_input_quantity;

		var book = {
		  'id': product.id,
      	  'name': product.title,
          'category': product.category,
      	  'brand' : product.publisher,
      	  'price': product.price,
      	  'variant' : product.type,
      	  'quantity': amount
		};

		if (product.coupon) {
		  book["coupon"] = product.coupon;
		}	

		ga('ec:addProduct', book);
	});

	if (step == null) return;
	
	ga('ec:setAction','checkout', {
      'step': step,
      'options': options
 	});
}

//on ready
$(trackingEvents);