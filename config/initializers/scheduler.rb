require 'rufus-scheduler'

s = Rufus::Scheduler.new

s.cron '00 12 * * *' do
  Project.where(:po_number.ne => nil).each do |project|
    project.orders.where(:shipment_date.lte => Date.today(),:shipment_details => nil).each do |order|
      SupplierMailer.enter_shipment_details(project.po_number,order.supplier_id,order.shipment_date.strftime("%Y-%B-%d"),order.id).deliver_now
    end
  end
end

#s.join