FactoryGirl.define do
  factory :admin, class: User do
    id 100
    created_on Time.now
    status 1 
    language 'en'
    salt "7599f9963ec07b5a3b55b354407120c0"
    hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
    admin true
    mail "test_admin@gmail.com"
    lastname "Admin"
    firstname "User"
    login "sazor_test_admin"
    gitlab_token "oim9b_ZecCzxnThLtvGg"
  end

  factory :user_1, class: User do
    id 101
    created_on Time.now
    status 1 
    language 'en'
    salt "7599f9963ec07b5a3b55b354407120c0"
    hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
    admin false
    mail "test_user1@gmail.com"
    lastname "Admin"
    firstname "User"
    login "sazor_test_1"
    gitlab_token "WzFj8mBgZPCDdn1NzgLc"
  end

  factory :user_2, class: User do
    id 102
    created_on Time.now
    status 1 
    language 'en'
    salt "7599f9963ec07b5a3b55b354407120c0"
    hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
    admin false
    mail "test_user2@gmail.com"
    lastname "Admin"
    firstname "User"
    login "sazor_test_2"
    gitlab_token "nxW6g9pptEmy34Hsd_bw"
  end
end