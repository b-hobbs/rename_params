describe RenameParams::Macros::Copy, type: :controller do
  context 'with :root' do
    controller(ActionController::Base) do
      copy :name, to: :root, namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'copy' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'copies billing_contact[:name] to root' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: { name: 'Marcelo' }, name: 'Marcelo'))
      end
    end
  end

  context 'with existent nested key' do
    controller(ActionController::Base) do
      copy :street, to: :billing_contact, namespace: [:billing_contact, :address]

      def update
        head :ok
      end
    end

    describe 'copy' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'copies billing_contact[:address][:street] to billing_contact[:street]' do
        put :update, with_params(billing_contact: { address: { street: '123 St' } })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: { address: {street: '123 St'}, street: '123 St' }))
      end
    end
  end

  context 'with non existent nested key' do
    controller(ActionController::Base) do
      copy :name, to: :contact, namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'copy' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'copies billing_contact[:name] to contact[:name]' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq( build_params(controller: 'anonymous', action: 'update', billing_contact: {name: 'Marcelo'}, contact: { name: 'Marcelo' }))
      end
    end
  end

  context 'with non existent deep nested key' do
    controller(ActionController::Base) do
      copy :name, to: [:contact, :info], namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'copy' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'copies billing_contact[:name] to contact[:info][:name]' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: { name: 'Marcelo' }, contact: { info: { name: 'Marcelo' } }))
      end
    end
  end
end
