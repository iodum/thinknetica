shared_examples_for 'Add files' do
  scenario 'can add several files', js: true do
    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Add'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

end