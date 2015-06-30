class ClientMailer < ApplicationMailer
  def quote(project_id)
    @project = Project.find(project_id)
    @client = Client.find(@project.client_id)
    attachments["artline_quote_#{@project.quote_number}.pdf"] = open(customer_qoute_project_url(@project.id, format: 'pdf')).read
    mail(from: ENV['SENDER'],to: @client.email,subject: 'Artline Quotation')
  end

end

