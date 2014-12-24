FROM rails:onbuild

ENV RAILS_ENV=production

RUN rake assets:precompile

ENTRYPOINT ["bin/deploy"]
