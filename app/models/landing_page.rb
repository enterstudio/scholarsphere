class LandingPage  < MailForm::Base

  attribute :contact_method,  :captcha  => true
  attribute :name,        :validate => false
  attribute :email,       :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
        :subject => "Landing Page Form: #{name} #{email}",
        :to => ScholarSphere::Application.config.landing_email,
        :from => ScholarSphere::Application.config.landing_from_email
    }
  end

end