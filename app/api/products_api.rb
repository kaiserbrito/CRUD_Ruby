module Products
	class ProductsAPI < Grape::API

		format :json

		desc "Product List", {
			:notes => <<-NOTE
			Get All Products
			 _________________
			NOTE
		}

		get do
			Product.all
		end

		desc "Product By Id", {
			:notes => <<-NOTE
			Get Product By Id
			 ___________________
			NOTE
		}

		params do
			requires :id, type: Integer, desc: "Product id"
		end

		get ':id' do
			begin
				product = Product.find(params[:id])			
			rescue ActiveRecord::RecordNotFound
				error!({ status: :not_found }, 404)				
			end
		end

		desc "Delete Product By Id", {
			:notes => <<-NOTE
			Delete Product By Id
			 ___________________
			NOTE
		}

		params do
			requires :id, type: Integer, desc: "Product id"
		end

		delete ':id' do
			begin
				product = Product.find(params[:id])	
				{ status: :success } if product.delete		
			rescue ActiveRecord::RecordNotFound
				error!({ status: :error, message: :not_found }, 404)				
			end
		end

		desc "Update Product By Id", {
			:notes => <<-NOTE
			Update Product By Id
			 ___________________
			NOTE
		}

		params do
			requires :id, type: Integer, desc: "Product id"
			requires :name, type: String, desc: "Product name"
			requires :price, type: BigDecimal, desc: "Product price"
			optional :old_price, type: BigDecimal, desc: "Product old price"
			requires :short_description, type: String, desc: "Product short description"			
			optional :full_description, type: String, desc: "Product full description"
		end

		put ':id' do
			begin
				product = Product.find(params[:id])
				if product.update({
									name: params[:name],
									price: params[:price],
									old_price: params[:old_price],
									short_description: params[:short_description],
									full_description: params[:full_description],
									})
					{ status: >success }
				else
					error!{( status: :error, message: product.errors.full_messages.first )} if product.errors.any?
				end
			rescue ActiveRecord::RecordNotFound
				error!({ satus: :error, message: :not_found }, 404)				
			end
		end

		desc "Create Product", {
			:notes => <<-NOTE
			Create Product
			 ___________________
			NOTE
		}

		params do
			requires :name, type: String, desc: "Product name"
			requires :price, type: BigDecimal, desc: "Product price"
			optional :old_price, type: BigDecimal, desc: "Product old price"
			requires :short_description, type: String, desc: "Product short description"			
			optional :full_description, type: String, desc: "Product full description"
		end

		post do
			begin
				product = Product.create({
									name: params[:name],
									price: params[:price],
									short_description: params[:short_description],
									full_description: params[:full_description],
									})
				if product.save
					{ status: >success }
				else
					error!{( status: :error, message: product.errors.full_messages.first )} if product.errors.any?
				end
			rescue ActiveRecord::RecordNotFound
				error!({ satus: :error, message: :not_found }, 404)				
			end
		end
	end
end