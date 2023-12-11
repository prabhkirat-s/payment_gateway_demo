ActiveAdmin.register PaymentHistory do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :payment_intent_id
    column :application_fee
    column :transfer_amount
    column :total_amount
    column :status
    column :created_at
    column 'Refund' do |payment_history|
      link_to 'Refund', refund_admin_payment_history_path(payment_history), method: :put
    end
    actions
  end




  # refund = Stripe::Refund.create({ payment_intent: 'pi_3OKxNXSEjLkHwIfL1KGeMMRM' })

  member_action :refund, method: :put do
    flash[:notice] = 'Custom action performed!'
    redirect_to admin_payment_histories_path
  end

end
